class UsersController < ApplicationController
  skip_before_filter :change_password_if_needed

  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    @user.update_attributes(params[:user])
    
    redirect_to user_path(@user)
  end 
    

  def change_password
    current_user.password                 = params[:user][:password]
    current_user.password_confirmation    = params[:user][:password_confimation]

    if current_user.valid?
      current_user.requires_password_change = false
      current_user.save
      redirect_to "/home"
    else
      flash[:alert] = current_user.errors.full_messages
    end
  end
end
