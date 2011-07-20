class UsersController < ApplicationController
  respond_to :json
  skip_before_filter :authenticate_user!, :only => [:index]
  skip_before_filter :change_password_if_needed, :only => [:index]
  before_filter :check_permissions, :except => [:index]

  def index
    respond_to do |format|
      format.html do
        authenticate_user!
        check_permissions
        @users = User.search(params[:search], params[:page],
          :sort => :name, :course_id => params[:course])
      end

      format.json do
        return unless authenticate_service
        @users = User.where(:github_account_name => params[:github]).all

        github_users = @users.map do |user|
          { :github  => user.github_account_name,
            :alumnus => user.alumnus?,
            :staff   => user.staff? }
        end

        render :json => github_users.to_json
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @github_repos = @user.github_repositories.
      paginate(:per_page => 10, :page => params[:page])
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
    current_user.password              = params[:user][:password]
    current_user.password_confirmation = params[:user][:password_confirmation]

    if current_user.valid?
      current_user.requires_password_change = false
      current_user.save
      redirect_to dashboard_path
    else
      flash[:alert] = current_user.errors.full_messages.to_sentence
    end
  end

  private

  def check_permissions
    return if params[:id] && User.find(params[:id]) == current_user

    unless current_access_level.allows? :view_directory
      flash[:error] = "Your account does not have access to this area"
      redirect_to dashboard_path
    end
  end
end
