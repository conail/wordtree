require 'csv'
require 'redis'

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

    root = 'red'

    sentences = Sentence.
      select("SUBSTR(clean, LOCATE('#{root} ', clean)) AS l").
      order('l DESC').
      find($r.smembers("search:#{root}")).
      map{|x| x.l.split(' ')}
    tree = []
    sentences.last.size.times do |i|
      x = sentences[-i]
      y = sentences[-i-1]
      p = longest_common_prefix(x,y).inspect
      #remainder = sentences[-i] - p
      puts p
    end
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
