require 'csv'
require 'redis'

namespace :admin do
  desc 'Read Documents into MongoDB.'
  task :read => :environment do
    METADATA = 'data/BAWE.csv'
    Document.delete_all
    a = %w[student_id code title level date module dgroup grade words sunits punits macrotype]
    CSV.foreach(METADATA, headers: :first_row) do |r|
      d = Document.create Hash[a.each_with_index.map{|a,i|[a,r[i]]}]
    end
  end

  # Words are added relative to sentences.
  # The end words only exist in one couple.
  #
  #
  desc 'Read Documents into MongoDB.'
  task :split => :environment do
    $r = Redis.new
    #$r.flushall
    Document.all.each do |document|
      puts document.id
      Nokogiri(File.open("data/CORPUS_UTF-8/#{document.code}.xml", 'rb')).
      css('body s').each do |sentence|
        words = sentence.text.strip.downcase.gsub(/[^a-z0-9 ]/, '').split(' ')
        0.upto(words.size - 1) {|i| $r.sadd "couple:#{words[0]}:#{words[1]}", document.id}
      end
    end
  end

  # Find a way to tie sentences to couples.
  desc ''
  task :sentencify => :environment do
    $r = Redis.new
    Document.all.each do |document|
      puts document.id
      Nokogiri(File.open("data/CORPUS_UTF-8/#{document.code}.xml", "rb")).
      css('body s').each_with_index do |sentence, i|
        words = sentence.text.strip.downcase.gsub(/[^a-z0-9 ]/, '').split(' ')
        0.upto(words.size - 1) {|i| $r.sadd "link:#{words[0]}:#{words[1]}", i}
      end
    end
  end

  desc ''
  task :post => :environment do
    $r = Redis.new
    $r.keys("link:*:*").each do |key|
      term = key.match(/:(\w+):/)[1]
      unless $r.exists("search:#{term}")
        puts term
        $r.send(:sunionstore, "search:#{term}", *$r.keys("link:#{term}:*")) 
      end
    end
  end
end
