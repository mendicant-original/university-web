class AdmissionsMailer < ActionMailer::Base
  include AdmissionsMailerHelper

  default :from => "rmu.management@gmail.com"

  def application_created(submission)
    @submission = submission

    mail(:to      => User.staff.map {|s| s.email } << "rmu.management@gmail.com",
         :subject => "[mendicant-admissions] New student application")
  end

  def application_reviewable(submission)
    @submission = submission

    mail(:to      => "mendicant-alumni@googlegroups.com",
         :subject => "[mendicant-admissions] New student application for review")
  end

  def application_received(submission)
    @submission = submission

    mail(:to      => submission.user.email,
         :subject => "[mendicant-admissions] Application received")
  end

  def application_comment_created(comment)
    @submission = comment.commentable
    @comment    = comment

    mail(:to      => to_admissions_submission(@submission),
         :subject => "[mendicant-admissions][#{@submission.user.name}] Comment added")
  end
end
