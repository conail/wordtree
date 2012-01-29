require 'tree_node'

class Tree < ActiveRecord::Base
  def load
    Marshal::load(body)
  end
end
