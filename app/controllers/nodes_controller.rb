class NodesController < ApplicationController
  def show
	  @node = Node.new(id: params[:id])
	  render json: @node.children.map(&:to_json)
  end
end
