class Comment < ActiveRecord::Base
  belongs_to :review, :polymorphic => true
end
