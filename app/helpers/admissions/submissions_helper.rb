module Admissions::SubmissionsHelper

  def submission_zip_path(submission)
    attachment_admissions_submission_path(submission.id,
      "#{Slugger.generate(submission.user.name)}-#{submission.id}",
      :format => "zip")
  end

  def link_to_submission_user(submission)
    if current_access_level.allows? :manage_users
      link_to submission.user.name, edit_admin_user_path(submission.user)
    else
      link_to submission.user.name, admissions_submission_path(submission)
    end
  end

  def submission_status_name(status)
    status.try(:name) || 'Unknown'
  end

  def submission_status_hex_color(status)
    status.try(:hex_color) || '333'
  end

end
