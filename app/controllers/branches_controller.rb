class BranchesController < ApplicationController
  def show
    @branch = Branch.new(name: params[:id], sset: 'all')
    render json: @branch.collocates.to_json
  end
end
