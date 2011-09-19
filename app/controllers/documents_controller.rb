class DocumentsController < InheritedResources::Base
  def index
    @documents = Document.order(:title).page(params[:page]).per(params[:per_page] || 30)
    @document = Document.new
  end
end
