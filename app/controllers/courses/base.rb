class Courses::Base < ApplicationController
  before_filter :find_course
  
  private
  
  def find_course
    @course = Course.find(params[:course_id])
  end
end