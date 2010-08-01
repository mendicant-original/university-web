class ApplicationController < ActionController::Base
  layout 'application'
  before_filter :authenticate_user!
  
  def welcome
    render :text => "Welcome to RMU!"
  end
end
