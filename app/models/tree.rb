require 'tree_node'

class Tree < ActiveRecord::Base
  def root
    Marshal::load(body)
  end
end
