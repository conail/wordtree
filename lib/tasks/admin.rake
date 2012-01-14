require 'csv'

include Tree

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
        s = Sentence.create text: x.text, clean: clean(x.text)
        words = s.clean.split(' ')
        0.upto(words.size - 1) {|i| $r.sadd "link:#{words[i]}:#{words[i+1]}", s.id}
        words.each {|w| $r.sadd "search:#{w}", s.id}
      end
    end
  end

  desc ''
  task treeify: :environment do
    # Create a MongoDB document for each word tree.
    # Quit if the same word is repeated.  

    term = 'of'
    cursor = [term]
    tree = {term => []}

    sentences = Sentence.
      select("SUBSTR(clean, LOCATE('#{term} ', clean)) AS l").
      order('l DESC').
      find($r.smembers("search:#{term}")).
      map{|x| x.l.split(' ')}
    sentences.reject!(&:empty?)
    
    max_length = sentences.max.size
    sentences.size.times do |i|
      0.upto(max_length) do |j|
        current_term = sentences[i][j]
        next_term    = sentences[i+1][j] unless i == sentences.size - 1
        prev_term    = sentences[i-1][j] unless i == 0

        # nothing to consider
        if sentences[i][j].nil? then

        elsif next_term != current_term then
          remainder << sentences[i].pop
        else
          n = TreeNode.new current_term
        end
      end
      f = sentences[i] - remainder.reverse
      puts f.inspect #if f.size > 2
    end
    puts max_length
    puts sentences.max.size
  end
end

def clean(str)
  str.strip.downcase.gsub(/[^a-z0-9 ]/, '')
end

def longest_common_prefix(a1, a2)
  min = [a1.size, a2.size].min
  min.times {|i| return a1.slice(0, i) if a1[i] != a2[i]}
  return a1.slice(0, min)
end
