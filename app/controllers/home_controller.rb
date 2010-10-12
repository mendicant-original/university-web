require 'rss'

class HomeController < ApplicationController
  before_filter :load_rss_items
  
  def show
    
  end
  
  private
  
  def load_rss_items
    rss_url = "http://blog.majesticseacreature.com/rss.xml?tag=rubymendicant"
    
    #rss_feed = RSS::Parser.parse(rss_url)
    
    @rss_items = [] #rss_feed.items[0..5]
  end
end