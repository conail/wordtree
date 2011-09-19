require 'csv'

namespace :admin do
  desc "Metadata"
  task(:metadata => :environment) do
    Document.delete_all
    Discipline.delete_all
    Genre.delete_all
    CSV.foreach('data/BAWE.csv', :headers => :first_row) do |row|
      d = Document.new
      d.student_id = row[0]
      d.code       = row[1]
      d.title      = row[2]
      d.level      = row[3]
      d.date       = row[4]
      d.module     = row[5]
      d.dgroup     = row[8]
      d.grade      = row[9]
      d.words      = row[10]
      d.sunits     = row[11]
      d.punits     = row[12]
      d.macrotype  = row[13]
      d.disciplines << Discipline.find_or_create_by_name(row[7].titleize.strip) unless row[7].nil? 
      unless row[6].nil?
        row[6].split('+').each do |x|
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
    Term.delete_all
    TermMapping.delete_all
    Document.all.each do |d|
      d.text.split(' ').each_with_index do |x, i| 
        puts x
        t = Term.find_or_create_by_name(x)
        TermMapping.create(:document_id => d.id, :term_id => t.id, :pos => i)
      end
    end 
  end

  desc "Connect"
  task(:connect => :environment) do
    Preterm.delete_all
    TermMapping.all.each do |tm|
      next if tm.pos == 1
      tm.term.preterms << tm.document.terms.where('pos = ?', tm.pos - 1)
      puts tm.document.id
    end
  end
end
