require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  context "Submission comment created" do
    setup do
      @course     = Factory(:course)
      @assignment = Factory(:assignment, :course => @course)
      @student    = Factory(:course_membership,
        :course => @course, :access_level => "student")
      @instructor = Factory(:course_membership,
        :course => @course, :access_level => "instructor")
      @comment    = Factory(:comment,
        :commentable => @assignment.submission_for(@student),
        :user        => @student.user)

      @email = UserMailer.submission_comment_created(@comment).deliver
    end

    test "sends email" do
      assert !ActionMailer::Base.deliveries.empty?
    end

    test "doesn't send email to the student making the comment" do
      assert !@email.to.include?(@student.user.email)
    end

    test "sends email to instructor" do
      assert_equal 1, @email.to.length
      assert @email.to.include?(@instructor.user.email)
    end

    test "doesn't cc anyone if Course#cc_comments is blank" do
      assert @course.cc_comments.blank?
      assert @email.cc.nil?
    end

    test "ccs if Course#cc_comments is set" do
      @course.update_attribute(:cc_comments, "mailinglist@rubymendicant.com")
      @comment.reload # Reload to capture the change in @course

      @email = UserMailer.submission_comment_created(@comment).deliver

      assert_equal 1, @email.cc.length
      assert @email.cc.include?(@course.cc_comments)
    end
  end
end
