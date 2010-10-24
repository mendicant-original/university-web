class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  has_many   :actions, :as => :actionable
  
  def on
    created_at.strftime("%m/%d/%Y %I:%M%p")
  end
end
