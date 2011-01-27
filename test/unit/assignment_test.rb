require "test_helper"

class AssignmentTest < ActiveSupport::TestCase
  context "#submission_for" do
    setup do
      @assignment = Factory(:assignment)
      @student    = Factory(:user)
    end

    test "create a submission for the given student when it does not exist" do
      submission = @assignment.submission_for(@student)
      assert submission.persisted?
      assert_equal @student, submission.user
    end

    test "finds the current submission when it already exists" do
      submission = Factory(:submission,
        :assignment => @assignment, :user => @student)

      other_submission = @assignment.submission_for(@student)
      assert other_submission.persisted?
      assert_equal submission, other_submission
      assert_equal @student, other_submission.user
    end

    test "configures default submission status for submission if it is blank" do
      status     = Factory(:submission_status)

      submission = @assignment.submission_for(@student)
      assert_equal status, submission.status
    end
  end

  context "#recent_activities" do
    setup do
      @assignment = Factory(:assignment)
      @activity1  = Factory(:activity,
        :actionable => @assignment, :created_at => 3.days.ago)
      @activity2  = Factory(:activity,
        :actionable => @assignment, :created_at => 1.day.ago)
    end

    test "finds all activities with last ones first" do
      recent_activities = @assignment.recent_activities
      assert_equal [@activity2, @activity1], recent_activities
    end

    test "maps submission activites together with assignment activities" do
      submission = Factory(:submission, :assignment => @assignment)
      activity3  = Factory(:activity,
        :submission => submission, :created_at => 2.days.ago)

      recent_activities = @assignment.recent_activities
      assert_equal [@activity2, activity3, @activity1], recent_activities
    end
  end
end
