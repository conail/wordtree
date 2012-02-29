class TreesController < ApplicationController
  def index
    @tree = Tree.new
  end

  def show
    headers['Last-Modified'] = Time.now.httpdate
    @tree = Tree.find_by_name(params[:id])
    if @tree.nil? then
      render 'errors/no_such_tree' 
      return
    end
  end
end
