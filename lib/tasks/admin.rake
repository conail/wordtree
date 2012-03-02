require 'csv'
require 'json'

namespace :admin do
  desc 'Reset'
  task reset: [:read, :split, :treeify]

  desc 'Read Documents into MySQL.'
  task read: :environment do
    METADATA = 'data/BAWE.csv'
    DATASRC  = 'data/CORPUS_UTF-8'
    
    Document.delete_all
    a = %w[student_id code title level date module genre_family discipline dgroup grade words sunits punits tables figures block quotes formulae lists listlikes abstract ws sp macrotype gender dob l1 education course texts complex]
    CSV.foreach(METADATA, headers: :first_row) do |r|
      d = Document.create Hash[a.each_with_index.map{|a,i|[a,r[i]]}]
      puts d.code
      d.xml = IO.read("#{DATASRC}/#{d.code}.xml")
      d.save
    end
  end

  # Words are added relative to sentences.
  # The end words only exist in one couple.
  desc 'Read sentences.'
  task split: :environment do
    $r.flushall
    Sentence.delete_all

    Document.all.each do |d|
      puts d.id

      Nokogiri(d.xml).css('body s').each do |x|
        s = Sentence.create(
          text:  x.text,
          clean: x.text.strip.downcase.gsub(/[^a-z0-9 ]/, '')
        )
        words = s.clean.split(' ')
        words.each_index do |i| 
          if words[i+1] then
            $r.sadd("link:#{words[i]}:#{words[i+1]}", s.id)
          end
          $r.sadd("search:#{words[i]}", s.id)
        end
      end
    end
  end

  desc ''
  # Store adjency lists for each source term, resulting in a series of weighted directed graphs.
  # The weights record occurence.
  # 
  # Terms are the vertices/list indexes.
  # Sentence ids are the edges.
  task vertex: :environment do
    term = 'red'
    sentence_ids = $r.smembers("search:#{term}")
    puts sentence_ids.size
    vertices = Set.new
    Sentence.all.each do |sentence|
      next unless sentence_ids.member?(sentence.id.to_s)
      vertices.merge(sentence.clean.split(' '))
      puts vertices.size
      puts vertices.inspect
    end
  end

  desc 'Build tree structure for each term.'
  task treeify: :environment do
   # Tree.delete_all
    words = $r.keys('search:*').map{|x| x[7..-1]}
    words = [words[14]]
    words.each do |term|
      tree = TreeNode.new(term)

      # Find the sentences relevant to the current term.
      sentences = $r.smembers("search:#{term}")
      puts "#{sentences.size}\t#{term}"

      sentences.each do |id|
        tree = tree.root
        txt = Sentence.find(id).clean
        rem = txt[txt.index(term)+term.size..-1].split(' ')
        rem.each do |word|
          tree = tree << TreeNode.new(word) 
        end
      end
=begin
      # Collapse the tree to a suffix array
      tree = tree.root
      tree.breadth do |n|
        n.collapse
        n.children.sort! do |a,b| 
          a.children.size <=> b.children.size
        end
      end
      Tree.create(name: term, body: Marshal::dump(tree))
=end
    end
  end
end
