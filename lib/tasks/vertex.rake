%w[csv json].each{|x| require x}

namespace :vertex do
  desc 'Read Documents into MySQL.'
  task read: :environment do
    METADATA = 'data/BAWE.csv'
    DATASRC  = 'data/CORPUS_UTF-8'
    
    Document.delete_all
    a = %w[student_id code title level date module genre_family discipline dgroup grade words sunits punits tables figures block quotes formulae lists listlikes abstract ws sp macrotype gender dob l1 education course texts complex]
    CSV.foreach(METADATA, headers: :first_row) do |r|
      d = Document.create Hash[a.each_with_index.map{|a,i|[a,r[i]]}]
      puts d.code
      d.xml = IO.read("#{DATASRC}/#{d.code}.xml")
      d.save
    end
  end

  desc 'Read sentences.'
  task split: :environment do
    Sentence.delete_all
    Document.all.each do |d|
      puts d.id
      Nokogiri(d.xml).css('body s').each do |x|
        s       = d.sentences.new
        s.text  = x.text
        s.clean = x.text.strip.downcase.gsub(/[^a-z0-9 ]/, '')
        s.save
      end
    end
  end

 
  desc 'Load Adjacency List'
  task init: :environment do
    $r.flushall
    i = 0
    Document.all.each do |doc|
      puts doc.id
      Nokogiri(doc.xml).css('body s').each do |sentence|
        i += 1
        $r.sadd("document:#{doc.id}", i)
        words = sentence.text.downcase.gsub(',', ' ,').gsub('.', ' .').split(' ')
        words.each_cons(2) do |vertices|
          $r.sadd("word:#{vertices.first}", doc.id)
          # Update document-level adjacency matrix
          $r.zincrby("edge:#{vertices.first}:#{vertices.last}", 1, i)
        end
      end
    end
  end

  # return a sorted set of destination words and frequencies given a source word and a document or sentence class.
  # union against sparse matrix?
  #
  # OUTPUT
  # source:term 
  # | the  | 1 |
  # | of   | 1 |
  # | then | 3 |
  # | four | 5 |
  # 
  # INPUT
  # sentenceclass
  # | the  | 1 |
  # | of   | 1 |
  # | then | 1 |
  # | four | 1 |
  #
  # sorted set 1: key: term:xxx occurrence
  # set 2: dynamic -- all the words within a sentenceclass
  # set 3: dynamic -- a sentence class -- a uid and then a set of sentence ids
  # set 4: documents to sentences
  # set 5: sentences to words
  #
  #
  # 1. search arrives with set of document ids and root term
  # 2. get set of relevant sentences
  # 3. get words within those sentences
  # x-1. get set of potential child terms
  # x. get sorted set of child terms for source
  

  #def normalize(str)
  #  str.downcase.gsub(/[^a-z0-9 ]/i, '').strip
  #end
end
