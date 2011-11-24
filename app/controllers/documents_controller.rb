class DocumentsController < InheritedResources::Base
  def index
    @documents = Document.find(:all, :sort => {:title => :desc}).paginate(:page => params[:page], :per_page => 40)
    @document = nil
  end 

  def create
    @documents = Document.order(:title).page(params[:page]).per(params[:per_page] || 30)
    @documents.where('genre_id IN ?', params[:document][:genre_ids])
    @document = Document.new
    render :action => :index, params => params
  end

  def show
    @document = Document.find(params[:id])
    params[:q] ||= @document.text.match(/^(\w+) /)[0].downcase # First word
    @term = Term.find(:name => params[:q]) 
    respond_to do |f| 
      f.html
      f.json do 
        render :json => @term.tree() #params[:depth])
      end
    end
  end
end
