class Comment < ActiveRecord::Base
  belongs_to :review, :polymorphic => true
  belongs_to :user
  
  def to_html
    RDiscount.new(comment_text).to_html
  end
end
