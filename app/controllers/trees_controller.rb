class TreesController < ApplicationController
  def index
    @tree = Tree.new
  end

  def show
    return if params[:search].nil?
    headers['Last-Modified'] = Time.now.httpdate
    @tree = Tree.find_by_name(params[:search])
    
    render 'errors/no_such_tree' and return if @tree.nil?

    respond_to do |f|
      f.html
      f.json do
        render(json: @tree)#.load
      end
    end
  end
end
