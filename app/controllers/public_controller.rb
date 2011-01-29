class PublicController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :change_password_if_needed
  before_filter      :set_current_section
  
  layout 'static'
  
  def alumni
    @alumni  = User.order("alumni_number").select {|u| u.alumnus? }
  end
  
  def changelog
    @announcements = Announcement.where(:public => true).order("created_at DESC")
    
    @announcements = @announcements.paginate(:page => params[:page])
  end
  
  def set_current_section
    @current = params[:action]
  end
end
