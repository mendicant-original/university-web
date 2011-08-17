class Courses::ReviewsController < Courses::Base
  before_filter :find_review

  def close
    @review.update_attribute(:closed, true)

    flash[:notice] = "#{@review} Request Closed."
    redirect_to course_assignment_submission_path(@course, @assignment, @submission)
  end

  def assign
    @review.update_attribute(:assigned_id,
      params[:assignment_evaluation][:assigned_id])

    flash[:notice] = "#{@review} Request Assigned."
    redirect_to course_assignment_submission_path(@course, @assignment, @submission)
  end

  private

  def find_review
    @review     = Assignment::Review.find(params[:id])
    @submission = @review.submission
    @assignment = @submission.assignment
    @course     = @assignment.course
  end
end
