class DocumentsController < InheritedResources::Base
  def index
    @documents = Document.order(:title).page(params[:page]).per(50)
    @document = Document.new
  end
end
