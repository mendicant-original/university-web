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
end
