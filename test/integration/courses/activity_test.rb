require 'test_helper'
require 'mocha'

module Courses
  class ActivityTest < ActionDispatch::IntegrationTest

    context "As a Student I want to view an activity" do

      setup do
        @user       = sign_user_in
        @course     = Factory(:course)
        @assignment = Factory(:assignment, :course => @course)
        Factory(:course_membership, :user => @user, :course => @course)

        @submission = @assignment.submission_for(@user)

        5.times do
          Factory(:activity, :actionable => @submission,
            :submission => @submission, :assignment => @assignment)
        end
      end

      test "view all activities" do
        visit course_path(@course, :anchor => "activity")

        assert_content "made something"
      end

      # This is currently broken in most web browsers but not reproducing here
      # https://www.pivotaltracker.com/story/show/14551241
      test "view an activity" do
        visit course_path(@course, :anchor => "activity")

        click_link(@course.activities.first.description)

        assert_current_path course_assignment_submission_path(@course, @assignment, @submission)
      end
    end
  end
end
