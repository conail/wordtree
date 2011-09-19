class TermMapping < ActiveRecord::Base
  has_many :terms
  has_many :documents
end
