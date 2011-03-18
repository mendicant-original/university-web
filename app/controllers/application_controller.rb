class ApplicationController < ActionController::Base
  layout 'application'
  before_filter :authenticate_user!
  before_filter :change_password_if_needed
  before_filter :set_timezone
  before_filter :link_return

  helper_method :current_access_level

  private

  def change_password_if_needed
    authenticate_user! unless user_signed_in?

    if current_user.requires_password_change?
      render "users/change_password"
    end
  end

  def set_timezone
    if current_user && !current_user.time_zone.blank?
      Time.zone = current_user.time_zone
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    "/"
  end

  def after_sign_in_path_for(resource_or_scope)
    dashboard_path
  end

  def current_access_level
    return current_user.access_level if current_user && current_user.access_level
    AccessLevel::User["guest"]
  end
  
  # returns the person to either the original url from a redirect_away or to a default url
  def redirect_back(*params)
    uri = session.delete(:original_uri)
    
    if uri
      redirect_to uri
    else
      redirect_to(*params)
    end
  end

  # handles storing return links in the session
  def link_return
    session[:original_uri] = params[:return_uri] if params[:return_uri]
  end
  
  def admin_required
    unless current_access_level.allows?(:manage_users)
      flash[:error] = "Your account does not have access to this area"
      redirect_to dashboard_path
    end
  end
end
