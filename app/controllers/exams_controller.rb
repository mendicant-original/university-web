class ExamsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :change_password_if_needed
  
  before_filter :find_course, :only => [:submit_exam]
  before_filter :find_submitted_status, :only => [:submit_exam]
  
  def entrance
    @user = User.new
  end
  
  def submit_exam
    @user = User.new(params[:user])
    
    if @user.entrance_exam_url.blank?
      @user.errors.add(:entrance_exam_url, "cannot be blank")
      render :action => :entrance
      
    elsif @user.save
      
      @user.course_memberships.create(:course_id => @course.id)
      
      @course.assignments.first.submission_for(@user).
        update_attribute(:submission_status_id, @submitted.id)
        
      @user.update_attribute(:requires_password_change, false)
      
      flash[:notice] = "Exam sucessfully submitted."
      
      sign_in(@user)
      
      redirect_to root_path
    else
      render :action => :entrance
    end
  end
  
  private
  
  def find_course
    @course = Course.find_by_name(ENTRANCE_EXAM_NAME)
  end
  
  def find_submitted_status
    @submitted = Assignment::SubmissionStatus.find_by_name('Submitted')
  end
end
