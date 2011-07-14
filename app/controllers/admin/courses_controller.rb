class Admin::CoursesController < Admin::Base
  before_filter :find_course, :only => [:show, :edit, :update, :destroy]
  before_filter :find_submission_statuses, :only => [:edit, :update]

  def index
    @courses = Course.order('start_date')
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(params[:course])
    puts "=========received: #{params[:course]}"
    puts "=======valid? #{@course.valid?}"
    puts "=========errors: #{@course.errors.inspect}"
    if @course.save
      flash[:notice] = "Course sucessfully created."
      redirect_to admin_courses_path
    else
      render :action => :new
    end
  end

  def update
    if @course.update_attributes(params[:course])
      flash[:notice] = "Course sucessfully updated."
      redirect_back admin_courses_path
    else
      render :action => :edit
    end
  end

  def destroy
    @course.destroy

    flash[:error] = @course.errors.full_messages.join(",")
    flash[:notice] = "Course sucessfully destroyed."

    redirect_to admin_courses_path
  end

  private

  def find_course
    @course = Course.find(params[:id])
  end

  def find_submission_statuses
    @statuses = Assignment::SubmissionStatus.order("sort_order").
                  map {|s| [s.name, s.id] }
  end
end
