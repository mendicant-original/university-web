require 'test_helper'

class Assignment::SubmissionTest < ActiveSupport::TestCase
  
  setup do
    @student = Factory(:user)
    @course = Factory(:course)
    @assignment = @course.assignments.create!
    @submission = @assignment.submissions.create!
  end
  
  test 'should have assignment associated with it' do
    assert @submission.respond_to?(:assignment)
  end
  
  test 'should have the correct assignment associated' do
    assert_equal @submission.assignment_id, @assignment.id
  end
  
  test 'should have a status associated with it' do
    assert @submission.respond_to?(:submission_status_id)
  end
  
  test 'should have a student associated with it' do
    assert @submission.respond_to?(:user_id)
  end
  
#  test 'should have the right student associated' do
#    assert_equal @submission.user_id, @student.id
#  end

  test 'should have many reviews' do
    assert @submission.respond_to?(:reviews)
  end
  
  test 'should be able to tell if the review is open or closed' do
    assert @submission.respond_to?(:open_review?)
  end
end
