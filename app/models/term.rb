class Term < ActiveRecord::Base
  has_many :term_mappings
  has_many :documents, :through => :term_mappings
end
