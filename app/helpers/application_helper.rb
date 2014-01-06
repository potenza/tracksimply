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

  def breadcrumbs(*crumbs)
    last = crumbs.pop

    content_tag :ol, class: "breadcrumb" do
      crumbs.each do |crumb|
        if crumb.instance_of? String
          concat(content_tag :li, link_to(crumb.split("/").last.titleize, crumb))
        else
          object = crumb.respond_to?(:last) ? crumb.last : crumb
          concat(content_tag :li, link_to(object, crumb))
        end
      end
      concat(content_tag :li, last, class: "active")
    end
  end

  def back(path, options = {})
    text = options[:text] || "Back"
    icon = options[:icon] || "chevron-left"
    css = options[:css] || "btn btn-default"

    link_to gicon(icon, text), path, class: css
  end
end
