class ApplicationController < ActionController::Base
  layout 'application'
  
  def welcome
    render :text => "Welcome to RMU!"
  end
end
