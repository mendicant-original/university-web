require 'test_helper'

class CourseMembershipTest < ActiveSupport::TestCase
  
  setup do
    @student = Factory(:user)
    @course = Factory(:course)
    @course_membership = @course.course_memberships.create!
  end
  
  test 'should create a course membership given a course and a student' do
    assert @course_membership.valid?
  end
  
  test 'should be associated with a course' do
    assert @course_membership.respond_to?(:course_id)
  end
  
  test 'should be associated with the right course' do
    assert_equal @course_membership.course_id, @course.id
  end
  
  test 'should be associated with a student' do
    assert @course_membership.respond_to?(:user_id)
  end
  
#  test 'should be associated with the right student' do
#    assert_equal @course_membership.user_id, @student.id
#  end
end
