require 'csv'
require 'nokogiri'

namespace :admin do
  desc "Metadata"
  task(:metadata => :environment) do
    CSV.foreach("data/BAWE.csv", :headers => :first_row) do |r|
      d = Document.new
      d.student_id = r[0]
      d.code       = r[1]
      d.title      = r[2] 
      d.level      = r[3]
      d.date       = r[4]
      d.module     = r[5]
      d.dgroup     = r[8]
	    d.grade      = r[9]
      d.words      = r[10]
      d.sunits     = r[11]
      d.punits     = r[12]
      d.macrotype  = r[13]
      d.save
      puts d.code # DEBUG

      t = Term.find_or_create_by(:name => 'XXSTARTXX')
      doc = Nokogiri(File.open("data/CORPUS_UTF-8/#{d.code}.xml", 'r'))
      doc.css('body s').map(&:text).join(' ').downcase.gsub(/[^a-z0-9 ]/, '').strip.split(' ').each do |term|
        t2 = Term.find_or_create_by(:name => term)
        rel = t.outgoing(:follows).find{|r| r[:document_id] == d.id}
        unless rel.nil? then
          rel[:count] += 1
          puts rel[:count]
          rel.save
        else
          Neo4j::Rails::Relationship.create(:follows, t, t2, :document_id => d.id, :count => 1)
        end
        t = t2
        puts t[:name]
      end
    end
  end
end
