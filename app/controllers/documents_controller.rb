class DocumentsController < InheritedResources::Base
  def index
    @documents = Document.order(:title).page(params[:page]).per(params[:per_page] || 30)
    @document = Document.new
  end

  def show
    @document = Document.find params[:id]
    @term = Term.find_by_name(params[:q])
    @term ||= @document.terms.group('terms.id').order('COUNT(terms.id) DESC').limit(1).first
    respond_to do |f| 
      f.html
      f.json { render :json => @term.preterm_tree(params[:depth])}
    end
  end
end
