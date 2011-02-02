class Admin::AnnouncementsController < Admin::Base
  before_filter :find_announcement, :only => [:edit, :update, :destroy]
  
  def index
    @announcements = Announcement.order("created_at DESC")
  end
  
  def new
    @announcement = Announcement.new(:author_id => current_user.id)
  end
  
  def create
    @announcement = Announcement.new(params[:announcement])
    
    if @announcement.save
      flash[:notice] = "Announcement successfully created."
      redirect_to admin_announcements_path
    else
      render :action => :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @announcement.update_attributes(params[:announcement])
      flash[:notice] = "Announcement successfully updated."
      redirect_to admin_announcements_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @announcement.destroy
    
    flash[:notice] = "Announcement successfully destroyed."
    redirect_to admin_announcements_path
  end
  
  private
  
  def find_announcement
    @announcement = Announcement.find(params[:id])
  end
  
end
