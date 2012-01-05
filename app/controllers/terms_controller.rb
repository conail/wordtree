class TermsController < ApplicationController
  def index
    return if params[:search].nil?
    @term = Term.new params[:search]
    respond_to do |fmt|
      fmt.html
      fmt.json do
        tree = @term.tree(params[:depth].to_i, params[:branching].to_i, params[:occurs].to_i)
        render json: JSON.pretty_generate(tree)
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
