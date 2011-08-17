class Courses::ReviewsController < Courses::Base
  before_filter :find_review

  def close
    @review.update_attribute(:closed, true)
    submission = @review.submission
    assignment = submission.assignment
    course     = assignment.course

    flash[:notice] = "#{@review} Request Closed."
    redirect_to course_assignment_submission_path(course, assignment, submission)
  end

  def assign
    #@review
  end

  private

  def find_review
    @review = Assignment::Review.find(params[:id])
  end
end
