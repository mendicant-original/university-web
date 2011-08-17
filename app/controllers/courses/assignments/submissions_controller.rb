class Courses::Assignments::SubmissionsController < Courses::Assignments::Base
  before_filter :find_submission,
    :only => %w(show edit update comment description associate_with_github
                close_review)
  before_filter :student_and_instructor_only,
    :only => %w(update close_review associate_with_github)

  def index
    @submissions = @assignment.submissions.sort_by {|s| s.last_active_on }.reverse
  end

  def show
    respond_to do |format|
      format.html { find_activities }
      format.text { render :text => @submission.description }
    end
  end

  def edit
    redirect_to :action => :show
  end

  def description
    @submission.update_description(current_user, params[:value])

    respond_to do |format|
      format.text
    end
  end

  def associate_with_github
    @submission.associate_with_github(params[:value])

    respond_to do |format|
      format.text
    end
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

    if @course.instructors.include?(current_user) && !params[:status].blank?
      @submission.update_status(current_user, SubmissionStatus.find(params[:status]))
    end

    comment_data = params[:comment].merge(:user_id => current_user.id)
    comment = @submission.create_comment(comment_data)

    unless comment.new_record?
      flash[:notice] = "Comment posted."
      redirect_to :action => :show
    else
      find_activities
      flash[:error] = comment.errors.map {|f, e| [f.to_s.humanize, e].join(" ") }.join(", ")
      render :action => :show
    end
  end

  private

  def find_submission
    @submission = Assignment::Submission.find(params[:id])
  end

  def find_activities
    @activities = @submission.activities.
      group_by_description(:order => 'created_at')
  end

  def student_and_instructor_only
    unless @submission.editable_by?(current_user)
      flash[:error] = "Only course instructors can update submissions"
      redirect_to :action => :edit
      return
    end
  end
end
