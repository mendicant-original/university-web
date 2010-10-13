require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  
  setup do
    @student = Factory(:user)
    @course = Factory(:course)
    @assignment = @course.assignments.create!
    @submission = @assignment.submissions.create!
  end
  
  test 'should create an assignment for a given course' do
    assert @assignment.valid?
  end
  
  test 'should have a course associated with it' do
    assert @assignment.respond_to?(:course_id)
  end

  test 'should have submissions associated with it' do
    assert @assignment.respond_to?(:submissions)
  end
  
  
end
