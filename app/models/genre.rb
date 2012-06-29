class Genre < ActiveRecord::Base
  has_many :documents
end
