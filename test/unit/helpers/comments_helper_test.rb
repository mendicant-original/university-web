require 'test_helper'

class CommentsHelperTest < ActionView::TestCase
  include CommentsHelper

  context "#link_to_comment" do

    setup do
      @comment = Factory(:comment)
    end

    should 'show the number of comment' do
      assert_match /#{@comment.user.name}'s comment/, link_to_comment(@comment)
    end

    should 'have a anchor link to comment' do
      assert_match /href="#1"/, link_to_comment(@comment)
    end
  end
end
