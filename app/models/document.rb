class Document < ActiveRecord::Base
  has_many :genre_memberships
  has_many :genres, :through => :genre_memberships
  has_and_belongs_to_many :disciplines
  has_many :term_mappings
  has_many :terms, :through => :term_mappings

  def self.search(q)
    q ? where('title LIKE ?', "%#{q}%") : scoped
  end

  def tokenize
    words = text.split(' ')
    words.each do |word|
      Word.create(:term => word)
    end
  end

  def title_fmd
    title.empty? ? 'N/A' : title[0, 200]
  end
end
