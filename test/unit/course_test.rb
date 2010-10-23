require 'test_helper'

class CourseTest < ActiveSupport::TestCase

  context 'a Course with two slots and one student' do
    setup do
      @subject = Course.create!(:name => 'A Course', :class_size_limit => 2)
      user = User.create!(:nickname => 'Me', :email => 'anybody@example.org', :password => '123456', :password_confirmation => '123456')
      @subject.students << user
    end

    should 'not be full' do
      assert !@subject.full?
    end

    should 'have one available slot' do
      assert_equal 1, @subject.available_slots
    end

  end

end
