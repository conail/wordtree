class Document < Neo4j::Model
  property :title,      :type => String
  property :student_id, :type => String
  property :level,      :type => String
  property :date,       :type => String
  property :module,     :type => String
  property :dgrade,     :type => String
  property :dgroup,     :type => String
  property :grade,      :type => String
  property :words,      :type => String
  property :sunits,     :type => String
  property :punits,     :type => String
  property :macrotype,  :type => String
  property :code,       :type => String

  index :title

  has_n :genres
  has_n :terms
  has_n :disciplines 

  def self.search(q)
    q ? where('title LIKE ?', "%#{q}%") : scoped
  end

  def tokenize
    text.split(' ').each{|w| Word.create_by_term word}
  end

  def title_fmd
    'N/A' and return if title.nil? or title.empty?
    title[0, 200]
  end

  def text
    doc = Nokogiri(File.open("data/CORPUS_UTF-8/#{code}.xml", 'rb').read)
    doc.css('body').text
  end
end
