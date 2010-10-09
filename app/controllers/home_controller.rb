require 'rss'

class HomeController < ApplicationController
  before_filter :load_rss_items
  
  def show
    
  end
  
  private
  
  def load_rss_items
    rss_url = "http://blog.majesticseacreature.com/rss.xml?tag=rubymendicant"

    begin
      rss_feed = RSS::Parser.parse(rss_url)
    rescue SocketError
      rss_feed = nil
    end

    @rss_items = (rss_feed.nil? ? [] : rss_feed.items[0..5])
  end
end
