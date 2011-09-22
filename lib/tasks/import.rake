require 'csv'

namespace :admin do
  desc "Metadata"
  task(:metadata => :environment) do
    [Document, Discipline, Genre].map(&:delete_all)
    CSV.foreach('data/BAWE.csv', :headers => :first_row) do |r|
      d = Document.new(:student_id => r[0], :code => r[1], :title => r[2], 
        :level => r[3], :date => r[4], :module => r[5], :dgroup => r[8], 
	:grade => r[9], :words => r[10], :sunits => r[11], :punits => r[12],
	:macrotype  => r[13])
      d.disciplines << Discipline.find_or_create_by_name(r[7].titleize.strip) unless r[7].nil? 
      unless r[6].nil?
        r[6].split('+').each do |x|
          x = x.nil? ? '' : x.titleize.strip
          d.genres << Genre.find_or_create_by_name(x)
        end
      end
      puts d.code
      doc = Nokogiri(File.open("data/CORPUS_UTF-8/#{d.code}.xml", 'r'))
      d.text = doc.css('body s').map(&:text).join(' ')
      d.save
    end
  end
  
  desc "Tokenize Keywords"
  task(:tokenize => :environment) do
    [Term, TermMapping].map(&:delete_all)
    Document.all.each do |d|
      d.text.split(' ').each_with_index do |x, i| 
        t = Term.find_or_create_by_name(x)
        TermMapping.create(:document_id => d.id, :term_id => t.id, :pos => i)
      end
    end 
  end

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
