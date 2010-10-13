require 'test_helper'

class Assignment::ReviewTest < ActiveSupport::TestCase

  setup do
    @student = Factory(:user)
    @course = Factory(:course)
    @assignment = @course.assignments.create!
    @submission = @assignment.submissions.create!
    @review = @submission.reviews.create!
  end
  
#  test 'should be able to create a valid review for a submission' do
#    assert @review.valid?
#  end
end
