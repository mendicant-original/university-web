class UserMailer < ActionMailer::Base
  include UserMailerHelper

  default :from => "rmu.management@gmail.com"

  def submission_comment_created(comment)
    @comment    = comment
    @submission = comment.commentable

    subject = "[rmu-submission] #{@submission.assignment.name}: " +
              "#{@submission.user.name}"

    mail(:to      => to_from_submission(@submission, @comment.user.email, true),
         :subject => subject)
  end

  def submission_updated(activity)
    @activity   = activity
    @submission = activity.actionable
    @user       = activity.user

    subject = "[rmu-submission] #{@submission.assignment.name}: " +
              "#{@submission.user.name}"

    mail(:to      => to_from_submission(@submission, @user.email),
         :subject => subject)
  end
  
  def application_created(submission)
    @submission = submission
    
    mail(:to      => User.staff.map {|s| s.email } << "rmu.management@gmail.com",
         :subject => "[rmu-admissions] New student application")
  end
  
  def application_reviewable(submission)
    @submission = submission
    
    mail(:to      => "rmu-alumni@googlegroups.com",
         :subject => "[rmu-admissions] New student application for review")
  end
  
  def application_received(submission)
    @submission = submission
    
    mail(:to      => submission.user.email,
         :subject => "[rmu-admissions] Application received")
  end
end
