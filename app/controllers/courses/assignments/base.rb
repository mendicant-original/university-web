class Courses::Assignments::Base < Courses::Base
  before_filter :find_assignment
  
  private
  
  def find_assignment
    @assignment = Assignment.find(params[:assignment_id])
  end
end