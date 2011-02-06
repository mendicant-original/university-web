class Admin::AssignmentsController < Admin::Base
  before_filter :find_course
  before_filter :find_assignment, :only => [:edit, :update, :destroy]
  before_filter :find_submission_statuses, :only => [:index, :edit, :update]

  def index

  end

  def new
    @assignment = Assignment.new
  end

  def create
    @assignment = @course.assignments.new(params[:assignment])

    if @assignment.save
      redirect_to admin_course_assignments_path(@course)
    else
      render :action => :new
    end
  end

  def update
    if @assignment.update_attributes(params[:assignment])
      redirect_back admin_course_assignments_path(@course)
    else
      render :action => :edit
    end
  end

  def destroy
    @assignment.destroy

    redirect_to admin_course_assignments_path(@course)
  end

  private

  def find_course
    @course = Course.find(params[:course_id])
  end

  def find_assignment
    @assignment = Assignment.find(params[:id])
  end

  def find_submission_statuses
    @statuses = Assignment::SubmissionStatus.order("sort_order").
                  map {|s| [s.name, s.id] }
  end

end
