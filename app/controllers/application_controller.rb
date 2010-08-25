class ApplicationController < ActionController::Base
  layout 'application'
  before_filter :authenticate_user!
  before_filter :change_password_if_needed
  
  def welcome
    render :text => "Welcome to RMU!"
  end

  def change_password_if_needed
    authenticate_user! unless user_signed_in?

    if current_user.requires_password_change?
      render "users/change_password"
    end
  end
  
  private 
  
  def current_access_level
    return current_user.access_level if current_user
    AccessLevel::User["guest"]
  end
end
