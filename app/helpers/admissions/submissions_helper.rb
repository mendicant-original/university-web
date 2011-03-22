module Admissions::SubmissionsHelper

  def submission_zip_path(submission)
    attachment_admissions_submission_path(submission.id, 
      "#{submission.user.name.underscore}_#{submission.id}", 
      :format => "zip")
  end
end
