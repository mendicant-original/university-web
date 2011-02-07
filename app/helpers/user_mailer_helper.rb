module UserMailerHelper

  def to_from_submission(submission, exclude_emails, include_commentors=false)
    to =  submission.assignment.course.instructors.map {|i| i.email }
    to += submission.comments.map {|c| c.user.email } if include_commentors
    to << submission.user.email

    to.uniq - [exclude_emails]
  end

  def escape_and_sanitize(text)
    Sanitize.clean(CGI.unescapeHTML(text)).html_safe
  end
end
