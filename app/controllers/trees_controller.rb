class TreesController < ApplicationController
  def index
    @tree = Tree.new
  end

  def create
    @tree = Tree.new(params[:tree]) 
    render action: :show
  end

  def show
    @tree = Tree.new  

    # Default is the set of all sentences
    #$r.sunionstore('sset', *$r.keys('document:*'))

    # Unless there is a set of proceeding terms that matches
    #unless $r.exists "focus:#{sset}:#{src}" then
  end
end
