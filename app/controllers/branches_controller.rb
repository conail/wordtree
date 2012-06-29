class BranchesController < ApplicationController
  def show
    @branch = Branch.find_or_create_by_name params[:id]

    render json: @branch.collocates.to_json
  end
end
