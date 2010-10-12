module UserMailerHelper
  
  def to_from_review(review, exclude_emails)
    to =  review.submission.assignment.course.instructors.map {|i| i.email }
    to << review.submission.user.email
    
    to.uniq - [exclude_emails]
  end
end