class UserSessionsController < Devise::SessionsController
  skip_before_filter :change_password_if_needed
  skip_before_filter :set_timezone
end
