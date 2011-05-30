require 'test_helper'

class Assignment::ExporterTest < ActiveSupport::TestCase
  setup do
    @assignment = Factory(:assignment, :description => "Assignment desc")
    @submission = Factory(:submission, :description => "My project",
                                       :assignment  => @assignment)

    @exporter   = Assignment::Exporter.new(@assignment)
  end

  context "#export" do
    test "exports assignment details" do
      data = @exporter.export

      assert_equal @assignment.name,        data[:name]
      assert_equal @assignment.description, data[:description]
    end

    test "exports submission details" do
      @submission.update_attributes :status => Factory(:submission_status)

      data            = @exporter.export
      submission_data = data[:submissions].first

      assert_equal @submission.description, submission_data[:description]
      assert_equal @submission.status.name, submission_data[:status]
    end

    test "exports comment details" do
      comment = @submission.comments.create(:user          => @submission.user,
                                            :comment_text => "This is text")

      data         = @exporter.export
      comment_data = data[:submissions].first[:comments].first

      assert_equal comment.updated_at,   comment_data[:updated_at]
      assert_equal comment.user.name,    comment_data[:user]
      assert_equal comment.comment_text, comment_data[:comment_text]
    end

    test "exports activity details" do
      activity = Factory(:activity, :submission => @submission,
                                    :user       => @submission.user)

      data          = @exporter.export
      activity_data = data[:submissions].first[:activities].first

      assert_equal activity.updated_at,  activity_data[:updated_at]
      assert_equal activity.user.name,   activity_data[:user]
      assert_equal activity.description, activity_data[:description]
    end
  end
end
