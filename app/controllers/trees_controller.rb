class TreesController < ApplicationController
  def index
    #@genres = Genre.order(:name).uniq.map{|x| [x.name, x.id]}
    #@disciplines = Discipline.order(:name).uniq.map{|x| [x.name, x.id]}
    @term = params[:q]
    @root = Tree.find_root(@term)

    @documents = if params[:discipline_id] then 
      @discipline = Discipline.find(params[:discipline_id])
      @discipline.documents
    else
      Document.all
    end
  end
end
