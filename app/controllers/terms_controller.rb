class TermsController < ApplicationController
  def index
    return if params[:search].nil?
    headers['Last-Modified'] = Time.now.httpdate
    @tree = Tree.find_by_name(params[:search])
    @term = Term.new
    
    render 'errors/no_such_tree' and return if @tree.nil?

    respond_to do |f|
      f.html
      f.json do
        render(json: Marshall::load(@tree.body))
      end
    end
  end
end
