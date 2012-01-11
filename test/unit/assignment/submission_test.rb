require 'test_helper'

class Assignment::SubmissionTest < ActiveSupport::TestCase

  context "#querying for submissions with github repo" do
    setup do
      @submission_with_github = Factory(:submission)
      @submission_with_github.associate_with_github('repo')

      @submission_without_github = Factory(:submission)
    end

    test "returns only submissions with a github repo" do
      submissions = Assignment::Submission.with_github_repository

      assert_equal 1, submissions.count
      assert_equal false, submissions.include?(@submission_without_github)
    end

  end

  context "storing commits on a submission" do
    setup do
      @submission = Factory(:submission)
      @submission.associate_with_github('repo')
      @now = Time.now
      @commit = Struct.new(:id, :commit_time, :message).new(
          "commit id",
          @now,
          "commit message"
      )
    end

    test "should store the most recent date and id" do
      @submission.add_github_commit(@commit)

      assert_equal @now, @submission.last_commit_time
      assert_equal "commit id", @submission.last_commit_id
    end

    test "create an activity for the commit" do
      @submission.add_github_commit(@commit)

      activity = @submission.activities.last
      assert_equal "committed: commit message", activity.description
      assert_equal "commit id-commit message",  activity.context
      assert_equal @now.to_i,                   activity.created_at.to_i
    end

  end

  context "#associate_with_github" do
    setup do
      @submission = Factory(:submission)
      @github_account = @submission.user.github_account_name
    end

    test "can handle full URL" do
      @submission.associate_with_github('https://github.com/username/github_repo')

      assert_equal "#{@github_account}/github_repo", @submission.github_repository
    end

    test "can handle a simple repo name" do
      @submission.associate_with_github('github_repo')

      assert_equal "#{@github_account}/github_repo", @submission.github_repository
    end

    test "adds an activity related to the github repository" do
      @submission.associate_with_github('github_repo')

      activity = @submission.activities.last
      assert_equal "updated github repository", activity.context
      assert_equal "updated github repository to: #{@github_account}/github_repo", activity.description
    end

  end

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

      test "escapes HTML elements" do
        @submission.create_comment(:comment_text => "This &amp; that <p>Go</p>",
                                   :user => Factory(:user))

        mail = ActionMailer::Base.deliveries.last

        assert !mail.body.to_s[/\&amp;/], "Body contains &amp;"
      end
    end
  end
end
