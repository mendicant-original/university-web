class Courses::Base < ApplicationController
  before_filter { @selected = :courses }
  before_filter :find_course
  before_filter :course_members_only

  private

  def find_course
    @course = Course.find(params[:course_id])
  end

  def course_members_only
    unless @course.users.include?(current_user) || current_access_level.allows?(:view_all_courses)
      flash[:error] = "You are not enrolled in this course!"
      redirect_to courses_path
    end
  end
end
