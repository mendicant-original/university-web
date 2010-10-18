class Courses::AssignmentsController < Courses::Base
    
  def show
    @assignment = @course.assignments.find(params[:id])
  end
  
end
