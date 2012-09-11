%w[csv json commander/import].each{|x| require x}

program :name, 'Foo Bar'
program :version, '1.0.0'
program :description, 'Stupid command that prints foo or bar.'

METADATA = 'data/BAWE.csv'
DATASRC  = 'data/CORPUS_UTF-8'

namespace :admin do
  desc 'Reset'
  task reset: [:drop, :read, :split, :treeify]

  desc 'Delete everything from persistent storage.'
  task drop: :environment do 
    puts 'Stage 0: Deleting old objects.'
    Document.delete_all
    Sentence.delete_all
    $r.flushall
  end

  desc 'Read Documents into Database.'
  task read: :environment do
    puts 'Stage 1: Reading CSV headers.  Takes up to a minute.'
    a = %w[student_id code title level date module genre discipline dgroup grade words sunits punits tables figures block quotes formulae lists listlikes abstract ws sp macrotype gender dob l1 education course texts complex xml]
    CSV.foreach(METADATA, headers: :first_row) do |r|
      r[6]  = Genre.create(name: r[6])
      r[7]  = Discipline.create(name: r[7])
      r[31] = IO.read("#{DATASRC}/#{r[1]}.xml")
      Document.create(Hash[a.each_with_index.map{|a,i|[a,r[i]]}])
    end
  end

  desc 'Read sentences.'
  task split: :environment do
    puts 'Stage 2: Parsing sentences.'
    progress Document.all do |d|
      # This is expensive!
      Nokogiri(d.xml).css('body s').each do |x|
        # D'oh! 's' tags sometimes contain multiple sentences.
        x.text.split(/\. /).map(&:strip).each do |sentence| 
          d.sentences.create(text: sentence)
        end
      end
    end
  end

  desc 'Read sentences.'
  task treeify: :environment do
    $r.flushall
    progress Sentence.all do |sentence|
      tokens = sentence.tokenize

      until tokens.empty? do
        Tree.add_tokens(tokens, sentence.document_id)
        tokens.shift
      end
    end
  end
end
