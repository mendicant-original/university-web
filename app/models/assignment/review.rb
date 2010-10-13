class Assignment::Review < ActiveRecord::Base
  after_create :update_submission_status
  
  belongs_to :submission
  belongs_to :closed_by, :class_name => "User"
  belongs_to :submission_status
  
  has_many :comments, :as => :commentable
  
  def course
    submission.assignment.course
  end
  
  def close!(user)
    closed_attr = {
      :closed               => true, 
      :closed_by_id         => user.id,
      :closed_date          => Time.now,
      :submission_status_id => submission.submission_status_id
    }
    
    update_attributes(closed_attr)
  end
  
  def description_html
    RDiscount.new(description).to_html.html_safe
  end
  
  private
  
  def update_submission_status
    unless submission.status.name == "Approved"
      submission.status = SubmissionStatus.find_by_name('Submitted')
    
      submission.save
    end
  end
end
