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
  
  def button_away(name, url, options = {})
    form_tag(url, :method => :get) do
      [
        hidden_field_tag('return_uri', url_for(:only_path => true)),
        submit_tag(name)
      ].join("\n").html_safe
    end
  end

  # Generates a map containing pins for all user locations. Uses Google Maps
  # Static API (http://code.google.com/apis/maps/documentation/staticmaps).
  #
  # Options:
  #   width,
  #   height: the width / height in pixels for the image; default for both
  #           is 512px
  #
  #   zoom_level: zoom level for the map; default is 0 ('world'). See
  #               http://code.google.com/apis/maps/documentation/staticmaps/#Zoomlevels
  #               for details.
  def user_map_tag(options={})
    width      = options[:width]      || 512
    height     = options[:height]     || 512
    zoom_level = options[:zoom_level] || 0

    markers = User.locations.map { |loc| loc.join(',') }.join('%7C')

    url = "http://maps.google.com/maps/api/staticmap?" +
      "sensor=false" +
      "&zoom=#{zoom_level}" +
      "&size=#{width}x#{height}" +
      "&markers=#{markers}"

    image_tag(url, :alt => 'User Map')
  end
end
