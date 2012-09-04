class TreesController < ApplicationController
  def index
    @tree = Tree.new
  end

  def create
    @tree = Tree.new(params[:tree]) 
    render action: :show
  end

  def show
    @root = Tree.find_root(params[:id])
    render 'not_found' and return if @root.nil?
    @tree = Tree.new(@root)
  end
end
