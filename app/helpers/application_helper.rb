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
  
  # TODO Most of this logic needs to be moved into a JS file.
  #
  def user_button
    link_to_function( 
      [ current_user.name, 
        image_tag("down_arrow.png", :class => "drop") 
      ].join.html_safe,
      "$('#user_dropdown').toggle(); $('#user a').toggleClass('active'); " +
      %{ if($('#user a').hasClass('active'))
           $('#user a img').attr('src', '/images/down_arrow_dark.png');
         else
           $('#user a img').attr('src', '/images/down_arrow.png');}
    )
  end
end
