class Assignment::Submission < ActiveRecord::Base
  belongs_to :status, :class_name  => "::SubmissionStatus", 
                      :foreign_key => "submission_status_id"
                      
  belongs_to :user
  belongs_to :assignment
  
  # TODO Remove after server data migration
  has_many :reviews,  :dependent => :delete_all
  
  has_many :comments,   :as => :commentable, :dependent => :delete_all
  has_many :activities, :dependent => :delete_all
  
  def create_comment(comment_data)
    comment = comments.create(comment_data)
    
    activities.create({
      :user_id       => comment.user,
      :description   => "#{comment.user.name} commented on a review",
      :actionable    => comment
    })
    
    UserMailer.submission_comment_created(comment).deliver
  end
  
  def update_status(user, new_status)
    activity = activities.create({
      :user_id     => user.id,
      :description => "Updated status from #{self.status.name} to " +
                      new_status.name,
      :actionable  => self
    })
    
    update_attribute(:submission_status_id, new_status.id)
    
    UserMailer.submission_updated(activity).deliver
  end
  
  def update_description(user, new_description)
    activity = activities.create({
      :user_id     => user.id,
      :description => "Updated description",
      :actionable  => self
    })
    
    update_attribute(:description, new_description)
    
    UserMailer.submission_updated(activity).deliver
  end
  
  def description_html
    RDiscount.new(description || "").to_html.html_safe
  end
  
  def editable_by?(user)
    assignment.course.instructors.include?(user) or self.user == user
  end
end
