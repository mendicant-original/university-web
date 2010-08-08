class UsersController < ApplicationController
  skip_before_filter :change_password_if_needed

  def change_password
    current_user.password                 = params[:user][:password]
    current_user.password_confirmation    = params[:user][:password_confimation]
    current_user.requires_password_change = false
    current_user.save
    redirect_to "/home"
  end
end
