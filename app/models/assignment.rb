class Assignment < ActiveRecord::Base
  has_many :submissions, :class_name => "Assignment::Submission"
  
  accepts_nested_attributes_for :submissions
  
  def submission_for(student)
    submissions.find_or_create_by_user_id(student.id, 
      :submission_status_id => Assignment::SubmissionStatus.order("sort_order").first)
  end
end
