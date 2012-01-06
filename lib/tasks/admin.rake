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
    $r = Redis.new
    $r.flushall
    Sentence.delete_all

    Document.all.each do |d|
      puts d.id

      Nokogiri(d.xml).css('body s').each do |x|
        str = x.text
        s = Sentence.create text: str, clean: str.strip.downcase.gsub(/[^a-z0-9 ]/, '')
        words = s.clean.split(' ')
        0.upto(words.size - 1) {|i| $r.sadd "link:#{words[i]}:#{words[i+1]}", s.id}
        words.each {|w| $r.sadd "search:#{w}", s.id}
      end
    end
  end
end
