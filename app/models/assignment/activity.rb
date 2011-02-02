class Assignment::Activity < ActiveRecord::Base
  before_create :set_assignment

  belongs_to :user
  belongs_to :assignment
  belongs_to :submission
  belongs_to :actionable, :polymorphic => true

  def on
    created_at.strftime("%m/%d/%Y %I:%M%p")
  end

  def type
    actionable.class.name.split('::').last || ''
  end

  private

  def set_assignment
    if assignment.nil? and not submission.nil?
      self.assignment_id = submission.assignment_id
    end
  end
end
