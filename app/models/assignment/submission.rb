class Assignment::Submission < ActiveRecord::Base
  belongs_to :status, :class_name  => "::SubmissionStatus", 
                      :foreign_key => "submission_status_id"
                      
  belongs_to :user
  belongs_to :assignment
  
  has_many :reviews, :dependent => :delete_all
  
  def review
    reviews.where(:closed => false).first
  end
  
  def open_review?
    !!review
  end
end
