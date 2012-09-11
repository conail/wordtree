module ApplicationHelper
  def title(str = 'Wordtree')
    content_for(:title, str.titleize)
  end
  
  def sortable(col, title = nil)
    col = col.to_s
    title ||= col.titleize
    css = (col == sort_col) ? "current #{sort_dir}" : nil
    dir = (col == sort_col and sort_dir == 'asc') ? 'desc' : 'asc'
    link_to(title, params.merge(:sort => col, :dir => dir, :page => nil), :class => css)
  end

private  
  def sort_col; params[:sort] || 'title'; end  
  def sort_dir; params[:dir] || 'asc'; end
end
