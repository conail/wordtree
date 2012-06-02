class Sentence < ActiveRecord::Base
  belongs_to :document

  def tokenize
    text.scan(/\w+(?:[-']\w+)*|'|[-.(]+|\S\w*/i)
  end
end
