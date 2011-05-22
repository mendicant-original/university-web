class HomeController < ApplicationController

  def show
    render :inline => "<%= user_map_tag %>"
  end
end
