module UserMailerHelper
  
  def to_from_submission(submission, exclude_emails)
    to =  submission.assignment.course.instructors.map {|i| i.email }
    to << submission.user.email
    
    to.uniq - [exclude_emails]
  end
end