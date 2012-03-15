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
    # Reset the cache.
    $r.flushall

    Document.all.each_with_index do |doc, i|
      puts i

      doc.sentences.each do |sentence|

        # Document to word mapping
        $r.sadd("document:#{doc.id}", sentence.id)

        # Tokenize 
        words = sentence.text.scan(/\w+/)
        words.each_cons(2) do |src, dst|

          #  Word to document word mapping
          $r.sadd("word:#{src}", sentence.id)

          # Update document-level adjacency matrix
          $r.zincrby("edge:#{src}:#{sentence.id}", 1, dst)
        end

        # Last word in sentence not covered by previous loop.
        $r.sadd("word:#{words.last}", sentence.id)
      end
    end
  end

  desc ''
  task words: :environment do
    # Get all the tokens in the corpus
    words = $r.keys('word:*').map!{|x| x[5..-1]}
    
    # make a sorted set for each words collocates
    words.each do |word|
      puts word
      keys = $r.keys("edge:#{word}:*")
      next if keys.empty?
      $r.zunionstore "branch:all:#{word}", keys
    end
  end

  # ---
  # source_term sentence_id sentence_id sentence_id
  # then intersect with document set
  # 
  # then (ruby) map the sentence ids to keys for that source term
  # 
  # worst case -- the

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
