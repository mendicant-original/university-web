class Assignment::Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignment
  belongs_to :submission
  
  def full_description
    description + " for assignment '#{assignment.name}'"
  end
end
