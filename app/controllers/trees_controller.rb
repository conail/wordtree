class TreesController < ApplicationController
  def index
    @tree = Tree.new
  end

  def show
    headers['Last-Modified'] = Time.now.httpdate

    @tree = Tree.new  
    @children = []
    params[:limit] ||= 10
    params[:offset] ||= 0 
    params[:source] ||= params[:id]

    unless $r.scard("set:#{params[:source]}") > 0 then
      $r.sunionstore(
        "set:#{params[:source]}", 
        "word:#{params[:source]}"
      )
    end

    word = params[:id]
    @keys= $r.sinter("set:#{params[:source]}", "word:#{word}")
    @keys.map!{|x| "edge:#{word}:#{x}"}
    $r.zunionstore("branch:#{params[:source]}:#{word}", @keys)
    $r.zrevrange(
      "branch:#{params[:source]}:#{word}", 
      params[:offset], 
      params[:limit], 
      with_scores: true).each_slice(2) do |name, keys|

      @children << {keys: keys.to_i, name: name}
    end
  end
end

