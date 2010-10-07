class Admin::SubmissionStatusesController < Admin::Base
  before_filter :find_submission_status, :only => [:edit, :update, :destroy]
  
  def index
    @submission_statuses = SubmissionStatus.all
  end
  
  def new
    @submission_status = SubmissionStatus.new
  end
  
  def create
    @submission_status = SubmissionStatus.new(params[:submission_status])
    
    if @submission_status.save
      redirect_to admin_submission_statuses_path
    else
      render :action => :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @submission_status.update_attributes(params[:submission_status])
      redirect_to admin_submission_statuses_path
    else
      render :action => :edit
    end
  end
  
  def destroy
    @submission_status.destroy
    
    redirect_to admin_submission_statuses_path
  end
  
  private
  
  def find_submission_status
    @submission_status = SubmissionStatus.find(params[:id])
  end
end
