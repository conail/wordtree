class Sentence
  include Mongoid::Document
  field :text
  field :clean
  field :_id, default: proc{Sequence[A].next}
  identity type: String
end
