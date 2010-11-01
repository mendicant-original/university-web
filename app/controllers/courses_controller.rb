class CoursesController < ApplicationController
  before_filter :find_course, :only => [:show, :notes]
  before_filter :course_members_only, :only => [:show, :notes]
  
  def index
    @courses    = current_user.courses
    @instructed = current_user.instructed_courses
  end
  
  def show
    @activities = @course.activities.paginate(:page => params[:page])
    
    respond_to do |format|
      format.html
      format.text { render :text => @course.notes }
    end
  end

  def notes
    @course.update_attribute(:notes, params[:value])

    respond_to do |format|
      format.text
    end
  end
  
  private
  
  def find_course
    @course = Course.find(params[:id])
  end
  
  def course_members_only
    unless @course.users.include?(current_user)
      flash[:error] = "You are not enrolled in this course!"
      redirect_to courses_path
    end
  end
end
