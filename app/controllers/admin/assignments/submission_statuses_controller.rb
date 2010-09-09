class Admin::Assignments::SubmissionStatusesController < Admin::Base
  before_filter :find_submission_status, :only => [:edit, :update, :destroy]
  
  def index
    @submission_statuses = Assignment::SubmissionStatus.all
  end
  
  def new
    @submission_status = Assignment::SubmissionStatus.new
  end
  
  def create
    @submission_status = Assignment::SubmissionStatus.new(params[:assignment_submission_status])
    
    if @submission_status.save
      redirect_to admin_assignments_submission_statuses_path
    else
      render :action => :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @submission_status.update_attributes(params[:assignment_submission_status])
      redirect_to admin_assignments_submission_statuses_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @submission_status.destroy
    
    redirect_to admin_assignments_submission_statuses_path
  end
  
  private
  
  def find_submission_status
    @submission_status = Assignment::SubmissionStatus.find(params[:id])
  end
end
