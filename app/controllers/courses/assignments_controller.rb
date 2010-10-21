class Courses::AssignmentsController < Courses::Base
    
  def show
    @assignment  = @course.assignments.find(params[:id])
    @submissions = @assignment.submissions.includes(:status).
                    order("submission_statuses.sort_order").group_by(&:status)
  end
  
end
