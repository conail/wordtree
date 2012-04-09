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
      add_children(node, term)
      q.join node[:children]
    end
  end

  def add_children(node, word)
    @keys = $r.sinter("trail", "word:#{word}")
    @keys.map!{|x| "edge:#{word}:#{x}"}
    $r.zunionstore("branch:#{params[:source]}:#{word}", @keys)
    $r.zrevrange(
      "branch:#{params[:source]}:#{word}", 
      params[:offset], 
      params[:limit], 
      with_scores: true).each_slice(2) do |name, keys|
      node[:children] << {keys: keys.to_i, name: name, children: []}
    end
  end

end
