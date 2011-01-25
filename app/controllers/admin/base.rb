module Admin
  class Base < ApplicationController
    before_filter :admin_required
    before_filter { @selected = :administration }
    layout "admin"

    private

    def admin_required
      unless current_access_level.allows?(:manage_users)
        flash[:error] = "Your account does not have access to this area"
        redirect_to dashboard_path
      end
    end
  end
end
