class UserSessionsController < Devise::SessionsController
  skip_before_filter :change_password_if_needed
end
