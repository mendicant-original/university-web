require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  context "index" do
    setup do
      @submission = Factory(:submission)
    end

    test "start with comment #1" do
      comment = @submission.comments.create(:comment_text => "dummy")
      assert_equal 1, comment.index
    end

    test "create a ascending index when are created" do
      @submission.comments.create(:comment_text => "dummy")
      second = @submission.comments.create(:comment_text => "dummy")
      third  = @submission.comments.create(:comment_text => "dummy")

      assert_equal 2, second.index
      assert_equal 3, third.index
    end
  end
end
