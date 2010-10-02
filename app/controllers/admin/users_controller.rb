class Admin::UsersController < Admin::Base
  before_filter :find_user, :only => [:show, :edit, :update, :destroy]
  
  def index
    @users = User.search(params[:search], params[:page])
    
  end
  
  def new
    @user = User.new
    
    build_nested_attributes
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.password.blank? and @user.password_confirmation.blank?
      password = User.random_password
      @user.password              = password
      @user.password_confirmation = password
    end
    
    if @user.save 
      update_access_level
      update_alumni_attributes
         
      redirect_to admin_users_path
    else
      render :action => :new
    end
  end
  
  def edit
    build_nested_attributes
  end
  
  def update
    update_access_level
    update_alumni_attributes
    
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
    
    if @user.update_attributes(params[:user])
      redirect_to admin_users_path
    else
      #raise @user.errors.inspect
      render :action => :edit
    end
  end
  
  def destroy
    @user.destroy
    
    flash[:notice] = @user.errors.full_messages.join(",")
    
    redirect_to admin_users_path
  end
  
  private
  
  def find_user
    @user = User.find(params[:id])
  end
  
  def update_access_level
    access_level = params[:user].delete("access_level")
    
    @user.update_attribute(:access_level, access_level)
  end
  
  def update_alumni_attributes
    [:alumni_number, :alumni_month, :alumni_year].each do |attribute|
      value = params[:user].delete(attribute.to_s)
      
      if attribute == :alumni_number and @user[:alumni_number].nil? and not value.nil?
        alumni_channel = Chat::Channel.find_by_name("#rmu-alumni")
        @user.chat_channel_memberships << Chat::ChannelMembership.new(:channel => alumni_channel)
      end

      @user.update_attribute(attribute, value)
    end
  end
  
  def build_nested_attributes
    @user.course_memberships.build if @user.course_memberships.empty?
    @user.chat_channel_memberships.build if @user.chat_channel_memberships.empty?
  end
end
