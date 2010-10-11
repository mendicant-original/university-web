require 'rss'

class HomeController < ApplicationController
  before_filter :load_rss_items
  
  def show
    
  end
  
  private
  
  # TODO: Load RSS Asynchronously via JS
  # Ticket # 5513669
  #
  def load_rss_items
    rss_url = "http://blog.majesticseacreature.com/rss.xml?tag=rubymendicant"
    
    @rss_items = []
  end
end
