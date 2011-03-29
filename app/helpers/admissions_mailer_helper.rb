module AdmissionsMailerHelper

  def to_admissions_submission(submission)
    to =  User.staff.map {|c| c.email }
    to += submission.comments.map {|c| c.user.email }

    to.uniq
  end
  
  def escape_and_sanitize(text)
    CGI.unescapeHTML(Sanitize.clean(text)).html_safe
  end
end
