module ApplicationHelper
  def title(str = '')
    content_for(:title, str)
  end
end
