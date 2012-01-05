class Couple
  include Mongoid::Document
  field :term, :type => String
  field :next_term, :type => String
  field :document_id, :type => Integer
end
