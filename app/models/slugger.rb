#encoding: UTF-8

module Slugger
  extend self

  def clean_smart_quotes(text)
    text.gsub! "\xe2\x80\x99", "'"
    text.gsub! "\xe2\x80\x98", "'"
    text.gsub! "\xe2\x80\x9c", '"'
    text.gsub! "\xe2\x80\x9d", '"'
    text
  end

  def generate(text)
    slug_text = clean_smart_quotes(text)
    slug_text.gsub!(/[?.!,:'"]/, '')
    slug_text.gsub!(/<[^>]+>/, '')
    slug_text.split(' ')[0..5].join('-').downcase
  end

end