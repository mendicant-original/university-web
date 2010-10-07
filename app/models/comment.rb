class Comment < ActiveRecord::Base
  belongs_to :review, :polymorphic => true
  belongs_to :user
  
  after_create :notify_users
  
  private
  
  def notify_users
    
  end
end
