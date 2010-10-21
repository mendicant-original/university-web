class Courses::Assignments::SubmissionsController < Courses::Assignments::Base
  before_filter :find_submission, :only => %w(show edit update comment)
  
  def index
    @submissions = @assignment.submissions
  end
  
  def show
    redirect_to :action => :edit
  end
  
  def edit
    
  end
  
  def update
    unless @course.instructors.include? current_user
      flash[:error] = "Only course instructors can update submissions"
      redirect_to :action => :edit
    else
      new_status = SubmissionStatus.find(params[:assignment_submission]['submission_status_id'])
      
      if @submission.update_status(current_user, new_status)
        flash[:notice] = "Assignment submission sucessfully updated."
        redirect_to course_assignment_path(@course, @assignment)
      else
        render :action => :edit
      end
    end
  end
  
  def comment
    @submission.create_comment(params[:comment].merge(:user_id => current_user.id))
    
    flash[:notice] = "Comment posted."
    redirect_to :action => :edit
  end
  
  private
  
  def find_submission
    @submission = Assignment::Submission.find(params[:id])
  end
end
