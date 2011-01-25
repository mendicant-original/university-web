module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def error_messages_for(object)
    if object.errors.any?
      content_tag(:div, :id => "errorExplanation") do
        content_tag(:h2) { "Whoops, looks like something went wrong." } +
        content_tag(:p) { "Please review the form below and make the appropriate changes." } +
        content_tag(:ul) do
          object.errors.full_messages.map do |msg|
            content_tag(:li) { msg }
          end.join('')
        end
      end
    end
  end

  def md(text, options={})
    html = RDiscount.new(text || "").to_html

    html = html.gsub(/<\/?p>/, '') if options[:no_p]

    return html.html_safe
  end
  
  def user_button
    link_to(
      [ current_user.name, 
        image_tag("down_arrow.png", :class => "drop") 
      ].join.html_safe,
      '#'
    )
  end
  
  def selected_arrow(section)
    return nil
    if defined?(@selected) && @selected == section
      image_tag "selected_arrow.png", :class => "selected"
    end
  end
end
