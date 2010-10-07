class Assignment::Submission < ActiveRecord::Base
  belongs_to :status, :class_name  => "::SubmissionStatus", 
                      :foreign_key => "submission_status_id"
                      
  belongs_to :user
  belongs_to :assignment
end
