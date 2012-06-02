%w[csv json].each{|x| require x}

namespace :vertex do
  desc 'Read Documents into MySQL.'
  task read: :environment do
    METADATA = 'data/BAWE.csv'
    DATASRC  = 'data/CORPUS_UTF-8'
    
    Document.delete_all
    a = %w[student_id code title level date module genre_family discipline 
           dgroup grade words sunits punits tables figures block quotes 
           formulae lists listlikes abstract ws sp macrotype gender dob l1 
           education course texts complex]
    CSV.foreach(METADATA, headers: :first_row) do |r|
      d = Document.create Hash[a.each_with_index.map{|a,i|[a,r[i]]}]
      puts d.code
      d.xml = IO.read("#{DATASRC}/#{d.code}.xml")
      d.save
    end
  end

  desc 'Read sentences.'
  task split: :environment do
    $r.flushall
    Sentence.delete_all
    Document.all.each do |d|
      puts d.id
      Nokogiri(d.xml).css('body s').each do |x|
        d.sentences.create(text: x.text)
      end
      d.sentences.select('id, text').each do |s|
        $r.sadd("document:#{d.id}", s.id)
        words = s.tokenize
        words.each_cons(2) do |src, dst|
          $r.zincrby("edge:#{src}:#{dst}", 1, s.id)
          $r.sadd("word:#{src}", s.id)
          $r.sadd("dst:#{src}", dst)
        end
        $r.sadd("word:#{words.last}", s.id)
      end
    end
  end
end
