class TermsController < ApplicationController
  def index
    return if params[:search].nil?
    headers['Last-Modified'] = Time.now.httpdate
    
    respond_to do |f|
      f.html
      f.json do
        render(json: Marshall::load(@tree.body))
      end
    end
  end
end
