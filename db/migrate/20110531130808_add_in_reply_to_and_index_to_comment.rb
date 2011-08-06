class AddInReplyToAndIndexToComment < ActiveRecord::Migration

  def self.add_index_to_commentables(commentables)
    commentables.each do |commentable|
      commentable.comments.each_with_index do |comment, index|
        comment.update_attributes(:index => index + 1)
      end
    end
  end

  def self.up
    add_column :comments, :in_reply_to_id,   :integer
    add_column :comments, :index, :integer

    add_index_to_commentables Assignment::Submission.all
  end

  def self.down
    remove_column :comments, :index
    remove_column :comments, :in_reply_to_id
  end
end
