%w[csv json commander/import].each{|x| require x}

program :name, 'Foo Bar'
program :version, '1.0.0'
program :description, 'Stupid command that prints foo or bar.'

METADATA = 'data/BAWE.csv'
DATASRC  = 'data/CORPUS_UTF-8'

namespace :admin do
  desc 'Reset'
  task reset: [:read, :split]

  desc 'Read Documents into Database.'
  task read: :environment do
    a = %w[student_id code title level date module genre discipline dgroup grade words sunits punits tables figures block quotes formulae lists listlikes abstract ws sp macrotype gender dob l1 education course texts complex xml]
    count = 0
    
    Document.delete_all
    CSV.foreach(METADATA, headers: :first_row) do |r|
      r[6]  = Genre.create(name: r[6])
      r[7]  = Discipline.create(name: r[7])
      r[31] = IO.read("#{DATASRC}/#{r[1]}.xml")
      Document.create(Hash[a.each_with_index.map{|a,i|[a,r[i]]}])
      puts count += 1
    end
  end

  desc 'Read sentences.'
  task split: :environment do
    count = 0

    $r.flushall
    Sentence.delete_all
    Document.all.each do |d|
      puts count += 1
      Nokogiri(d.xml).css('body s').each do |x|
        # s tags sometimes contain multiple sentences.
        x.text.split(/\. /).map(&:strip).each do |sentence| 
          d.sentences.create(text:  sentence)
        end
      end

      d.sentences.select('id, text').each do |s|
        $r.sadd("document:#{d.id}", s.id)
        s.tokenize.each_cons(2) do |src, dst|
          $r.zincrby("edge:#{src}:#{dst}", 1, s.id)
          $r.sadd("word:#{src}", s.id)
          $r.sadd("dst:#{src}", dst)
        end
        $r.sadd("word:#{s.tokenize.last}", s.id)
      end
    end
  end

  # NODE
  # -----------------------------------------------------------------
  #
  # - id -- unique identifier
  # - depth -- useful for inspection, maybe wildcard searches
  # - children set
  # - document membership
  # - terminal / text -- terminal nodes can have suffixes
  #
  # NOT CONSIDERING
  # - sentence membership -- required for later extraction
  #
  # DATA STRUCTURE
  # - roots     -> Hash [ id ]
  # - node:id   -> Hash [ Depth, Terminal, Suffix, Parent ]
  # - children  -> Set  [ node_id ]
  # - documents -> Ordered Set [ document_id]

  desc 'Read sentences.'
  task treeify: :environment do
    Node.delete_all

    progress Sentence.all do |sentence|
      tokens = sentence.tokenize

      until tokens.empty? do
        Tree.add_tokens(tokens)
        tokens.shift
      end
    end
  end
end
