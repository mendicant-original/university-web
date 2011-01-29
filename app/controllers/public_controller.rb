class PublicController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :change_password_if_needed
  
  layout 'static'
  
  def alumni
    @current = 'alumni'
    @alumni  = User.order("alumni_number").select {|u| u.alumnus? }
  end
  
  def changelog
    @current = 'changelog'
    @announcements = Announcement.where(:public => true).order("created_at DESC")
    
    @announcements = @announcements.paginate(:page => params[:page])
  end
end
