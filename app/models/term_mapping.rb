class TermMapping < ActiveRecord::Base
  belongs_to :term
  belongs_to :document
end
