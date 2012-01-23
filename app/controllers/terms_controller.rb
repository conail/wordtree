class TermsController < ApplicationController
  def index
    return if params[:search].nil?
    @term = Term.new(params[:search])
    @tree = Tree.find_by_name(params[:search])
    respond_to do |fmt|
      fmt.html
      fmt.json do
        render json: @tree.root.json
      end
    end
  end

  def show
    @term = Term.new params[:search]
    respond_to do |fmt|
      fmt.html
      fmt.json { render json: @term.tree(1)}
    end
  end
end
