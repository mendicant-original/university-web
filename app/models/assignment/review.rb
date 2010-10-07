class Assignment::Review < ActiveRecord::Base
  after_create :update_submission_status
  
  belongs_to :submission
  
  has_many :comments, :as => :commentable
  
  def course
    submission.assignment.course
  end
  
  private
  
  def update_submission_status
    unless submission.status.name == "Approved"
      submission.status = SubmissionStatus.find_by_name('Submitted')
    
      submission.save
    end
  end
end
