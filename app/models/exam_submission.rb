class ExamSubmission < ActiveRecord::Base
  belongs_to :user
  belongs_to :exam
  belongs_to :submission_status
end
