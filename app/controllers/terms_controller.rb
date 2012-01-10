class TermsController < ApplicationController
  def index
    return if params[:search].nil?
    @term = Term.new(params[:search], params[:level])
    respond_to do |fmt|
      fmt.html
      fmt.json do
        depth     = params[:depth].to_i
        branching = params[:branching].to_i
        occurs    = params[:occurs].to_i
        tree = @term.tree(depth, branching, occurs)
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
