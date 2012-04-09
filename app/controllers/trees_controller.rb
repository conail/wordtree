class TreesController < ApplicationController
  def index
    @tree = Tree.new
  end

  def show
    headers['Last-Modified'] = Time.now.httpdate

    @tree = Tree.new  
    params[:limit] ||= 10
    params[:offset] ||= 0 
    params[:source] ||= params[:id]

    unless $r.scard("set:#{params[:source]}") > 0 then
      $r.sunionstore(
        "set:#{params[:source]}", 
        "word:#{params[:source]}"
      )
    end

    # maintain ancestor trail
    $r.sinterstore("trail", "set:#{params[:source]}")
    
    # add the parent on each level down
    # must be breadth-first search
    #$r.sinterstore("trail", "trail", "word:no")

    word = params[:id]
    @parent = {name: word, children: []}
    q = [@parent]
    until q.empty? do
      node = q.pop
      add_children(node, word)
      q.join node[:children]
    end
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

