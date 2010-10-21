class Assignment::Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignment
  belongs_to :submission
  belongs_to :actionable, :polymorphic => true

  def on
    created_at.strftime("%m/%d/%Y %I:%M%p")
  end
end
