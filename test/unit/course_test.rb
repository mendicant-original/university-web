require 'test_helper'

class CourseTest < ActiveSupport::TestCase

  context 'a Course with two slots and one student' do
    setup do
      @subject = Factory(:course, :class_size_limit => 2)
      @subject.students << Factory(:user)
    end

    should 'not be full' do
      assert !@subject.full?
    end

    should 'have one available slot' do
      assert_equal 1, @subject.available_slots
    end

  end

end
