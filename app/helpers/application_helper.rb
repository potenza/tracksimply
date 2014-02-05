module ApplicationHelper
  def title(page_title)
    content_for :title, " - #{page_title}"
  end

  def page_title(page_title)
    title page_title

    content_tag :div, class: "page-header" do
      content_tag :h1, page_title
    end
  end

  def gicon(icon, text = nil)
    icon = content_tag :span, "", class: "glyphicon glyphicon-#{icon}"
    icon += " #{text}" if text
    icon
  end
end
