class CoursesController < ApplicationController
  before_filter { @selected = :courses }
  before_filter :find_course, :only => [:show, :notes, :directory, :search]
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
      :sort => "course_memberships.access_level ASC",
      :course_id => @course.id, :per_page => 7)

    @grouped_users = @users.group_by do |user|
      user.current_course_membership(@course).access_level.to_s.humanize
    end

    @reviews = @course.reviews(current_user)

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

  def search
    @search_key = params[:search]
    @results = @course.search_course_resources(@search_key)   
    
    respond_to do |format|
      format.js
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
