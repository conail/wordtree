require 'tree_node'

class Tree < ActiveRecord::Base
  def load
    Marshal::load(body)
  end
  
  def generate(term, source, limit, offset)
    ssrc = "set:#{source}"
    $r.sunionstore(ssrc, "word:#{source}") unless $r.scard(ssrc) > 0

    # maintain ancestor trail
    $r.sinterstore("trail", ssrc)
    
    @parent = {name: term, children: []}
    q = [@parent]
    until q.empty? do
      node = q.pop
      @keys = $r.sinter("trail", "term:#{term}")
      @keys.map!{|x| "edge:#{term}:#{x}"}
      branch = "v:branch:#{source}:#{term}"
      #$r.zunionstore(branch, @keys)
      #$r.zrevrange(branch, offset, limit, with_scores: true).each_slice(2) do |name, keys|
      #  node[:children] << {keys: keys.to_i, name: name, children: []}
      #end
      q.join node[:children]
    end
  end
end
