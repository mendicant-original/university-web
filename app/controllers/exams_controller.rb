class ExamsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :change_password_if_needed

  before_filter :find_exam, :only => [:submit_exam]
  before_filter :find_submitted_status, :only => [:submit_exam]

  def entrance
    @user = User.new
    @entrance_exam = @user.exam_submissions.build
  end

  def submit_exam
    exam_url       = params[:user].delete('exam_submission')
    @user          = User.new(params[:user])
    @entrance_exam = @user.exam_submissions.new(:url => exam_url['url'])

    if exam_url['url'].blank?
      @user.errors.add(:exam_url, "cannot be blank")
      render :action => :entrance
    elsif @user.save
      @user.update_attribute(:requires_password_change, false)

      @user.exam_submissions.create(exam_url.merge(:submission_status_id => @submitted.id,
                                                   :exam_id              => @exam.id))

      flash[:notice] = "Exam sucessfully submitted."

      sign_in(@user)

      redirect_to dashboard_path
    else
      render :action => :entrance
    end
  end

  private

  def find_exam
    # TODO: Replace w/ Exam#hash lookup
    #@exam = Exam.find_by_name(ENTRANCE_EXAM_NAME)
  end

  def find_submitted_status
    @submitted = Assignment::SubmissionStatus.find_by_name('Submitted')
  end
end
