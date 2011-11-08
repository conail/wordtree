require 'csv'
require 'nokogiri'
require 'redis'

namespace :admin do
#  desc "Metadata"
#  task(:metadata => :environment) do
#    [Document, Discipline, Genre].map(&:delete_all)
#    CSV.foreach('data/BAWE.csv', :headers => :first_row) do |r|
#      d = Document.new
#      d.student_id => r[0]
#      d.code       => r[1]
#      d.title      => r[2] 
#      d.level      => r[3]
#      d.date       => r[4]
#      d.module     => r[5]
#      d.dgroup     => r[8]
#	    d.grade      => r[9]
#      d.words      => r[10]
 #           d.sunits     => r[11]
 #           d.punits     => r[12]
	#          d.macrotype  => r[13]
 #           unless r[7].nil? 
 #             d.disciplines << Discipline.find_or_create_by_name(r[7].titleize.strip)
 #           end
 #           # Some documents have more than one genre.  Genres are delimited by '+'s
 #           unless r[6].nil?
 #             r[6].split('+').each do |x|
 #               x = x.nil? ? '' : x.titleize.strip
 #               d.genres << Genre.find_or_create_by_name(x)
 #             end
 #           end
 #           puts d.code # DEBUG
#      
 #           doc = Nokogiri(File.open("data/CORPUS_UTF-8/#{d.code}.xml", 'r'))
 #           
 #           # incorrect
 #           d.text = doc.css('body s').map(&:text).join(' ')
 #           d.save
 #         end
 #       end
 
  # Tokenize keywords.
  # ------------------
  #
  # Keywords are contained within sentences.  Sentences exist within <p> tags.
  #  
  desc "Tokenize Keywords"
  task(:tokenize => :environment) do
    r = Redis.new
    r.flushall
    i = 0
    Dir['data/CORPUS_UTF-8/*.xml'].each do |filename|
      puts filename
      doc = Nokogiri(File.open(filename))
      doc.css('body s').each do |sentence|
        r.rpush('sentences', sentence.text)
        sentence.text.downcase.gsub(/[^a-z0-9 ]/, '').strip.split(' ').each do |word|
          r.sadd('word:' << word, i)
        end
        i += 1
      end
    end 
  end

  # Connects terms to the terms that come directly before or after.
  #
  # This should be obsolete as it only connects each term to that directly following it.
  # In other words, it is not tree-based.
  desc "Connect"
  task(:connect => :environment) do
    [Preterm, Postterm].map(&:delete_all)
    TermMapping.all.each do |tm|
      a = tm.document.terms
      tm.term.preterms  << a.where('pos = ?', tm.pos - 1) unless tm.pos == 1
      tm.term.postterms << a.where('pos = ?', tm.pos + 1) unless tm.pos == a.size - 1
    end
  end
end
