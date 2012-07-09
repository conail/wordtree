# Tree has a source word and a sset -- sentence set

class Tree < ActiveRecord::Base
  attr_accessor :level, :genre, :discipline

  def sset_id(level = nil, genre = nil, discipline = nil)
    $r.sunionstore('sset', *$r.keys('document:*'))
  end


end
