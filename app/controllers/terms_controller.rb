class TermsController < ApplicationController
  def index
    return if params[:search].nil?
    headers['Last-Modified'] = Time.now.httpdate
    @term = Term.new(params[:search])
    @tree = Tree.find_by_name(params[:search])
    @genres = [] #Document.select(:dgroup).order(:dgroup).map(&:dgroup).reject{|x| x.nil?}.uniq.map(&:titleize)
    @disciplines = [] #Document.select(:grade).order(:grade).map(&:grade).reject{|x| x.nil?}.uniq.map(&:titleize)
    respond_to do |fmt|
      fmt.html
      fmt.json do
        render json: @tree.load.json
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
