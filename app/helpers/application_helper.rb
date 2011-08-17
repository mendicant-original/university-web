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
          end.join("\n").html_safe
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

  def button_away(name, url, options = {})
    form_tag(url, :method => :get) do
      [
        hidden_field_tag('return_uri', url_for(:only_path => true)),
        submit_tag(name)
      ].join("\n").html_safe
    end
  end

  def get_last(collection_size, index)
    collection_size == index ? "last" : ""
  end

  def hex2rgb(hex)
    r,g,b = hex[0..1], hex[2..3], hex[4..5]
    [r,g,b].map {|e| e.to_i(16)}
  end
end
