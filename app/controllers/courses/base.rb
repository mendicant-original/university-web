class Courses::Base < ApplicationController
  before_filter :find_course
  before_filter :students_and_instructors_only
  
  private
  
  def find_course
    @course = Course.find(params[:course_id])
  end
  
  def students_and_instructors_only
    if !@course.students.include?(current_user) and
       !@course.instructors.include?(current_user)
      
       flash[:notice] = "You are not enrolled in this course!"
       redirect_to courses_path 
    end
  end
end