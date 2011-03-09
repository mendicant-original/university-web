module Slugger
  extend self
  
  def clean_smart_quotes(text)
    text.gsub! "\342\200\230", "'"
    text.gsub! "\342\200\231", "'"
    text.gsub! "\342\200\234", '"'
    text.gsub! "\342\200\235", '"'  
    text
  end

  def generate(text)
    slug_text = clean_smart_quotes(text)
    slug_text.gsub!(/[?.!,:'"]/, '')
    slug_text.gsub!(/<[^>]+>/, '')
    slug_text.split(' ')[0..5].join('-').downcase
  end
  
end