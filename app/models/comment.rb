class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  has_many   :actions, :as => :actionable
  
  validates_presence_of :comment_text

  def on
    created_at.strftime("%m/%d/%Y %I:%M%p")
  end
end
