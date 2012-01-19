class TermsController < ApplicationController
  def index
    return if params[:search].nil?
    @term = Term.new(params[:search])
    @word = Word.find_by_name(params[:search])
    respond_to do |fmt|
      fmt.html
      fmt.json do
        depth     = 4
        branching = 50
        occurs    = 2
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
