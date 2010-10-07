class Assignments::ReviewsController < ApplicationController
  before_filter :find_assignment_submission
  
  def index
    @reviews = Assignment::Review.where(:submission_id => @submission.id)
  end
  
  private
  
  def find_assignment_submission
    @assignment = Assignment.find(params[:assignment_id])
    @submission = @assignment.submission_for(current_user)
  end
end
