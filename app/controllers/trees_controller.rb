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
    @tree.generate(params[:id], params[:source], params[:limit], params[:offset])
  end
end
