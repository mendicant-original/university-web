class UsersController < ApplicationController
  skip_before_filter :change_password_if_needed

  def index
    @users = User.all.sort_by {|u| u.name }
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    if @user.update_attributes(params[:user]) 
      flash[:notice] = "Profile sucessfully updated"
      redirect_to user_path(@user)
    else
      render :action => :edit
    end
  end 
    

  def change_password
    current_user.password                 = params[:user][:password]
    current_user.password_confirmation    = params[:user][:password_confimation]

    if current_user.valid?
      current_user.requires_password_change = false
      current_user.save
      redirect_to dashboard_path
    else
      flash[:alert] = current_user.errors.full_messages
    end
  end
end
