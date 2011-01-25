class Assignment < ActiveRecord::Base
  has_many :submissions, :class_name => "Assignment::Submission",
                         :dependent  => :destroy
  has_many :activities,  :as         => :actionable,
                         :dependent  => :delete_all

  belongs_to :course

  accepts_nested_attributes_for :submissions

  def submission_for(student)
    submission = submissions.find_or_create_by_user_id(student.id)

    if submission.submission_status_id.nil?
      submission.update_attribute(:submission_status_id,
        SubmissionStatus.default.try(:id))
    end

    submission
  end

  def recent_activities
    (activities + submissions.map {|s| s.activities }).flatten.
    sort_by {|a| a.created_at}.reverse
  end
end
