class GenreMembership < ActiveRecord::Base
  belongs_to :genre
  belongs_to :document
end
