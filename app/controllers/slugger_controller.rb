class SluggerController < ApplicationController
  def index
    @slug = Slugger.generate(params[:text])
    
    render :text => @slug
  end
end
