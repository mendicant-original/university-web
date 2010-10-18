class Assignment::Review < ActiveRecord::Base
  after_create :update_submission_status, :create_activity
  
  belongs_to :submission
  belongs_to :closed_by, :class_name => "User"
  belongs_to :submission_status
  
  has_many :comments, :as => :commentable
  has_many :actions,  :as => :actionable
  
  def course
    submission.assignment.course
  end
  
  def status
    if closed?
      if closed_by
        "Closed on #{closed_date.strftime("%d %B %Y")} by #{closed_by.name}"
      else
        "Closed"
      end
    else
      "Open"
    end
  end
  
  def close!(user)
    closed_attr = {
      :closed               => true, 
      :closed_by_id         => user.id,
      :closed_date          => Time.now,
      :submission_status_id => submission.submission_status_id
    }
    
    update_attributes(closed_attr)
    
    submission.assignment.activities.create({
      :user_id       => user.id,
      :submission_id => submission,
      :description   => "#{user.name} closed a review",
      :actionable    => self
    })
    
    UserMailer.review_closed(self, user).deliver
  end
  
  def create_comment(comment_data)
    comment = comments.create(comment_data)
    
    submission.assignment.activities.create({
      :user_id       => comment.user,
      :submission_id => submission,
      :description   => "#{comment.user.name} commented on a review",
      :actionable    => comment
    })
    
    UserMailer.review_comment_created(comment, self, comment.user).deliver
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
  
  def create_activity
    submission.assignment.activities.create({
      :user_id       => submission.user,
      :submission_id => submission,
      :description   => "#{submission.user.name} requested a review",
      :actionable    => self
    })
  end
end
