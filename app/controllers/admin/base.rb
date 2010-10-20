module Admin
  class Base < ApplicationController
    before_filter :admin_required
    layout "admin"
    
    private
    
    def admin_required
      unless current_access_level.allows?(:manage_users)
        flash[:error] = "Your account does not have access to this area"
        redirect_to root_path
      end
    end
  end
end