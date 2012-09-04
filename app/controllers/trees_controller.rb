class TreesController < ApplicationController
  def index
    @tree = Tree.new
  end

  def create
    @tree = Tree.new(params[:tree]) 
    render action: :show
  end

  def show
    root = Tree.find_root(params[:id])
    @tree = Tree.new(root)
  end
end
