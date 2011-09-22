class DocumentsController < InheritedResources::Base
  def index
    @documents = Document.order(:title).page(params[:page]).per(params[:per_page] || 30)
    @document = Document.new
  end

  def create
    @documents = Document.order(:title).page(params[:page]).per(params[:per_page] || 30)
    @documents.where('genre_id IN ?', params[:document][:genre_ids])
    @document = Document.new
    render :action => :index, params => params
  end

  def show
    @document = Document.find params[:id]
    @term = Term.find_by_name(params[:q])
    @term ||= @document.terms.group('terms.id').order('COUNT(terms.id) DESC').limit(1).first
    respond_to do |f| 
      f.html
      f.json do 
        if params[:t] == 'pre'
          render :json => @term.preterm_tree(params[:depth])
	else
          render :json => @term.postterm_tree(params[:depth]) 
	end
      end
    end
  end
end
