class Admin::UsersController < Admin::Base
  before_filter :find_user, :only => [:show, :edit, :update, :destroy]

  def index
    @users = User.search(params[:search], params[:page])
  end

  def show
    redirect_to edit_admin_user_path(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    # Disable until user password email is in place
    #
    # if @user.password.blank? and @user.password_confirmation.blank?
    #   password = User.random_password
    #   @user.password              = password
    #   @user.password_confirmation = password
    # end

    if @user.save
      update_protected
      update_alumni_attributes

      flash[:notice] = "User sucessfully created"

      redirect_to admin_users_path
    else
      render :action => :new
    end
  end

  def edit

  end

  def update
    update_protected
    update_alumni_attributes

    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    if @user.update_attributes(params[:user])
      flash[:notice] = "User sucessfully updated"

      redirect_to admin_users_path
    else
      #raise @user.errors.inspect
      render :action => :edit
    end
  end

  def destroy
    @user.destroy

    flash[:notice] = "User sucessfully deleted"

    redirect_to admin_users_path
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def update_protected
    access_level = params[:user].delete("access_level")
    inactive     = params[:user].delete("inactive")

    @user.update_attribute(:access_level, access_level)
    @user.update_attribute(:inactive, inactive)
  end

  def update_alumni_attributes
    [:alumni_number, :alumni_month, :alumni_year].each do |attribute|
      value = params[:user].delete(attribute.to_s)

      @user.update_attribute(attribute, value)
    end
  end
end
