class Courses::Assignments::SubmissionsController < Courses::Assignments::Base
  before_filter :find_submission, :only => %w(show edit update comment description)
  before_filter :student_and_instructor_only, :only => %w(update)
  def index
    @submissions = @assignment.submissions
  end
  
  def show
    respond_to do |format|
      format.html { redirect_to :action => :edit }
      format.text { render :text => @submission.description }
    end    
  end
  
  def edit
    
  end
  
  def description
    @submission.update_description(current_user, params[:value])
    
    render :text => @submission.description_html
  end
  
  def update    
    new_status = SubmissionStatus.find(params[:assignment_submission]['submission_status_id'])
    
    if @submission.update_status(current_user, new_status)
      flash[:notice] = "Assignment submission sucessfully updated."
      redirect_to :action => :edit
    else
      render :action => :edit
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
  
  def student_and_instructor_only
    unless @submissions.editable_by?(current_user)
      flash[:error] = "Only course instructors can update submissions"
      redirect_to :action => :edit
      return
    end
  end
end
