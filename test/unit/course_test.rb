require 'test_helper'

class CourseTest < ActiveSupport::TestCase

  context 'a Course with two slots and one student' do
    setup do
      @subject = Factory(:course, :class_size_limit => 2)
      @subject.course_memberships.create(:user => Factory(:user),
        :access_level => 'student')
    end

    should 'not be full' do
      assert !@subject.full?
    end

    should 'have one available slot' do
      assert_equal 1, @subject.available_slots
    end
  end

  context 'Course#start_end' do
    context 'for a course with no start date' do
      setup do
        @course = Factory(:course, :start_date => nil, :end_date => 3.weeks.from_now)
      end
      should 'be nil' do
        assert_nil @course.start_end
      end
    end

    context 'for a course with a start date and an end date' do
      setup do
        @course = Factory(:course, :start_date => 2.days.ago, :end_date => 3.weeks.from_now)
      end
      should 'be a range from its start date to its end date' do
        assert_equal((@course.start_date..@course.end_date), @course.start_end)
      end
    end
  end

end
