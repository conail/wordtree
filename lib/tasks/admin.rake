require 'csv'

include Tree

class TreeNode
  def path
    p = []
    x = self
    p << x && x = x.parent while x
    p
  end
end

namespace :admin do
  desc 'Reset'
  task reset: [:read, :split]

  desc 'Read Documents into MySQL.'
  task read: :environment do
    METADATA = 'data/BAWE.csv'
    DATASRC  = 'data/CORPUS_UTF-8'
    
    Document.delete_all

    a = %w[student_id code title level date module dgroup grade words sunits punits macrotype]
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
        s = Sentence.create(text: x.text, clean: clean(x.text))
        words = s.clean.split(' ')
        words.each_index do |w| 
          $r.sadd("link:#{words[i]}:#{words[i+1]}", s.id) if words[i+1]
          $r.sadd("search:#{words[i]}", s.id)
        end
      end
    end
  end

  desc ''
  task treeify: :environment do
    # Create a MongoDB document for each word tree.
    # Quit if the same word is repeated.  

    term = 'even'
    node = TreeNode.new(term)
    tree = node

    sentences = Sentence.
      select("SUBSTR(clean, LOCATE('#{term} ', clean)) AS l").
      order('l DESC').
      find($r.smembers("search:#{term}")).
      map{|x| x.l.split(' ')}.
      reject!(&:empty?)
    
    # the quick brown
    # the quick brown
    # the quick
    #   sentences.size
    sentences.each do |sentence|
      begin
        node << TreeNode.new(sentence.last)
      rescue
        puts sentence.last
        puts node.children.size
      end
    end
  end
end

def clean(str)
  str.strip.downcase.gsub(/[^a-z0-9 ]/, '')
end
