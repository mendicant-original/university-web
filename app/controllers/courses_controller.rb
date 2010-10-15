class CoursesController < ApplicationController
  before_filter :find_course, :only => [:show]
  before_filter :students_and_instructors_only, :only => [:show]
  
  def index
    @courses = current_user.courses
  end
  
  def show
    
  end
  
  private
  
  def find_course
    @course = Course.find(params[:id])
  end
  
  def students_and_instructors_only
    if !@course.students.include?(current_user) and
       !@course.instructors.include?(current_user)
      
      flash[:notice] = "You are not enrolled in this course!"
      redirect_to courses_path
    end
  end
end
