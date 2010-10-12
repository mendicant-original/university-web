class UserMailer < ActionMailer::Base
  include UserMailerHelper
  
  default :from => "rmu.management@gmail.com"
  
  def review_comment_created(comment, review, current_user)
    @comment = comment
    @review  = review 
    
    subject = "[rmu-review] #{review.submission.assignment.name}: " +
              "#{review.submission.user.name}"
    
    mail(:to      => to_from_review(review, current_user.email), 
         :subject => subject)
  end
  
  def review_created(review)
    @review = review
    
    subject = "[rmu-review] #{review.submission.assignment.name}: " +
              "#{review.submission.user.name}"
    
    mail(:to      => to_from_review(review, ''),
         :subject => subject)
  end
  
  def review_closed(review, current_user)
    @review    = review
    @closed_by = current_user
    
    subject = "[rmu-review] #{review.submission.assignment.name}: " +
              "#{review.submission.user.name}"
    
    mail(:to      => to_from_review(review, current_user.email),
         :subject => subject)
  end
end
