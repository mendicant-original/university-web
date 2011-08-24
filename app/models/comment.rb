class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  has_many   :activities,  :class_name => "Assignment::Activity",
                           :dependent  => :delete_all,
                           :as         => :actionable
  has_many   :reviews,     :class_name => "Assignment::Review",
                           :dependent  => :delete_all

  belongs_to :in_reply_to, :class_name => "Comment"

  validates_presence_of :comment_text

  before_create :setup_index

  def on
    created_at.strftime("%m/%d/%Y %I:%M%p")
  end

  private

  def setup_index
    last_comment = self.commentable.comments.order("created_at").last
    self.index = last_comment ? last_comment.index + 1 : 1

    return true
  end
end
