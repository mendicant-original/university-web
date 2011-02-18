class CoursesController < ApplicationController
  before_filter { @selected = :courses }
  before_filter :find_course, :only => [:show, :notes, :directory]
  before_filter :course_members_only, :only => [:show, :notes, :directory]

  def index
    @courses    = current_user.student_courses.archived
    @instructed = current_user.instructor_courses.archived
    @mentored   = current_user.mentor_courses.archived
  end

  def show
    @activities = @course.activities.paginate(:per_page => 10,
                                              :page     => params[:activity_page])

    @users = User.search(params[:search], params[:user_page],
      :sort => :name, :course_id => @course.id, :per_page => 7)
      
    all_course_users = User.includes(:course_memberships).where(["course_memberships.course_id = ?", @course.id])
    @timezones = {}
    all_course_users.each do |user|
      @timezones[user.time_zone] ||= []
      @timezones[user.time_zone] << user
    end
    
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

  def directory

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
