class Genre < ActiveRecord::Base
  has_many :genre_memberships
  has_many :documents, :through => :genre_memberships

  validates_uniqueness_of :name
end
