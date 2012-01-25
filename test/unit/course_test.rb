require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  test "requires a valid name" do
    course = Course.new(:name => "", :term => Factory(:term))
    assert !course.valid?

    course.name = "Foo"
    assert course.valid?
  end

  test "requires an unique name" do
    term    = Factory(:term)
    course  = Course.create!(:name => "Foo", :term => term)
    course2 = Course.new(    :name => "Foo", :term => term)
    assert !course2.valid?, "Course name is not unique"

    course2.name = "Bar"
    assert course.valid?
  end

  test "a course can be created with an instructor already associated" do
    term = Factory :term
    user = Factory :user, :access_level => :admin
    course = Course.create!({
      :name => "Foo",
      :term_id => term.id,
      :course_memberships_attributes => [{
        :user_id => user.id,
        :access_level => :instructor
      }]
    })

    assert_equal 1, Course.count
    assert_equal 1, course.instructors.reload.count
    assert_equal user.name, course.instructors.first.name
  end

  context ".active" do
    test "finds only not archived courses" do
      archived_course     = Factory(:course, :archived => true)
      non_archived_course = Factory(:course, :archived => false)

      assert_equal [non_archived_course], Course.active
    end
  end

  context ".archived" do
    test "finds only already archived courses" do
      archived_course     = Factory(:course, :archived => true)
      non_archived_course = Factory(:course, :archived => false)

      assert_equal [archived_course], Course.archived
    end
  end

  context "membership" do
    setup do
      @course     = Factory(:course)
      @student    = Factory(:course_membership,
        :course => @course, :access_level => "student")
      @mentor     = Factory(:course_membership,
        :course => @course, :access_level => "mentor")
      @instructor = Factory(:course_membership,
        :course => @course, :access_level => "instructor")
    end

    context "#students" do
      test "finds only student members" do
        assert_equal [@student.user], @course.students
      end
    end

    context "#instructors" do
      test "finds only instructors members" do
        assert_equal [@instructor.user], @course.instructors
      end
    end

    context "#mentors" do
      test "finds only mentor members" do
        assert_equal [@mentor.user], @course.mentors
      end
    end
  end

  context 'a Course with two slots and one student' do
    setup do
      @subject = Factory(:course, :class_size_limit => 2)
      @subject.course_memberships.create(:user => Factory(:user),
        :access_level => 'student')
    end

    test 'not be full' do
      assert !@subject.full?
    end

    test 'have one available slot' do
      assert_equal 1, @subject.available_slots
    end
  end

  context 'Course#start_end' do
    context 'for a course with no start date' do
      setup do
        @course = Factory(:course, :start_date => nil, :end_date => 3.weeks.from_now)
      end
      test 'be nil' do
        assert_nil @course.start_end
      end
    end

    context 'for a course with a start date and an end date' do
      setup do
        @course = Factory(:course, :start_date => 2.days.ago, :end_date => 3.weeks.from_now)
      end
      test 'be a range from its start date to its end date' do
        assert_equal((@course.start_date..@course.end_date), @course.start_end)
      end
    end
  end

  context "Course#search" do
    context "when you search" do
      setup do
        @course = Factory(:course, :notes => 'note', :description => 'Lorem ipsum')
      end

      test "should return an empty array" do
        assert @course.search('qdwkrvekrvjbnerkjn').values.all? {|k| k.empty? }
      end

      test "should return notes" do
        assert !@course.search('note')[:notes].empty?
      end

      test "should return assignments" do
        assignment = Factory(:assignment, :course => @course, :description => "This is an assigment")
        assert !@course.search('assigment')[:assignments].empty?
      end

      test "should return submission" do
        assignment = Factory(:assignment, :course => @course)
        Factory(:submission, :assignment => assignment, :description => "This is a submission")
        assert !@course.search('submission')[:submissions].empty?
      end

      test "should return submission's comments" do
        assignment = Factory(:assignment, :course => @course)
        submission = Factory(:submission, :assignment => assignment)
        comment    = Factory(:comment, :commentable => submission, :comment_text => 'comment')
        assert !@course.search('comment')[:submission_comments].empty?
      end

      test "should return irc messages" do
        channel      = Factory(:chat_channel)
        chat_message = Factory(:chat_message, :channel => channel, :body => 'message')
        @course      = Factory(:course, :channel => channel)
        assert !@course.search('message')[:irc_messages].empty?
      end

      test 'should not return assignments of other courses' do
        other_course = Factory(:course)
        assignment   = Factory(:assignment,
                               :course => other_course,
                               :description => 'test')
        assert @course.search('test')[:assignments].empty?
      end

      test 'should not return submissions of other courses' do
        other_course = Factory(:course)
        assignment   = Factory(:assignment, :course => other_course)
        submission   = Factory(:submission, :assignment => assignment,
                               :description => 'test')
        assert @course.search('test')[:submissions].empty?
      end
    end
  end
end
