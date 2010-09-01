class Admin::CoursesController < Admin::Base
  before_filter :find_course, :only => [:show, :edit, :update, :destroy]
  
  def index
    @courses = Course.all
  end
  
  def new
    @course = Course.new
  end
  
  def create
    @course = Course.new(params[:course])
    
    if @course.save 
      redirect_to admin_courses_path
    else
      render :action => :new
    end
  end
  
  def update
    if @course.update_attributes(params[:course])
      redirect_to admin_courses_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @course.destroy
    
    flash[:notice] = @course.errors.full_messages.join(",")
    
    redirect_to admin_courses_path
  end
  
  private
  
  def find_course
    @course = Course.find(params[:id])
  end
end
