namespace :vertex do
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
  # set 1 key: term:xxx occurrence
  # 
  

  #def normalize(str)
  #  str.downcase.gsub(/[^a-z0-9 ]/i, '').strip
  #end
end
