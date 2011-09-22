class DocumentsController < InheritedResources::Base
  def index
    redirect_to :action => :show, :id => 1
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
    #redirect_to(:action => :show, params.merge(:q => 'the')) if params[:q].nil?
    # threshold 
    # limit to the end of a sentence 
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
