require 'test_helper'

class Assignment::SubmissionTest < ActiveSupport::TestCase
  context "#create_comment" do
    setup do
      @submission = Factory(:submission)
    end

    test "creates a comment" do
      other_user = Factory(:user)
      assert_equal 0, @submission.comments.count

      @submission.create_comment(:comment_text => "My comment!",
                                 :user => other_user)
      comment = @submission.comments.first
      assert comment.persisted?
      assert_equal other_user, comment.user
      assert_equal "My comment!", comment.comment_text
    end

    test "adds an activity related to the comment" do
      @submission.create_comment(:comment_text => "My comment!",
                                 :user => @submission.user)

      activity = @submission.activities.last
      assert_equal "made a comment", activity.description
      assert_equal "My comment!", activity.context
      assert_equal @submission.comments.last, activity.actionable
    end

    context "email notification" do
      setup do
        ActionMailer::Base.deliveries.clear
      end

      test "does not deliver email to submission user when he comments" do
        @submission.create_comment(:comment_text => "My comment!",
                                   :user => @submission.user)

        mail = ActionMailer::Base.deliveries.last
        assert_equal [], mail.to
      end

      test "delivers email to submission user when someone else comment" do
        @submission.create_comment(:comment_text => "My comment!",
                                   :user => Factory(:user))

        mail = ActionMailer::Base.deliveries.last
        assert_equal [@submission.user.email], mail.to
      end

      test "delivers email to instructors" do
        instructor = Factory(:course_membership,
                             :course       => @submission.assignment.course,
                             :access_level => "instructor")
        @submission.create_comment(:comment_text => "My comment!",
                                   :user => Factory(:user))

        mail = ActionMailer::Base.deliveries.last
        assert_equal [instructor.user.email, @submission.user.email], mail.to
      end
    end
  end
end
