class DocumentsController < InheritedResources::Base
  def index
    @documents = Document.order(:title).page(params[:page]).per(params[:per_page] || 30)
    @document = Document.new
  end

  def show
    @document = Document.find params[:id]
    @term = params[:q] || @document.terms.group('terms.id').order('COUNT(terms.id) DESC').limit(1).first.name
    respond_to {|f| f.html; f.json}
  end
end
