class UserMailer < ActionMailer::Base
  include UserMailerHelper

  default :from => "rmu.management@gmail.com"

  def submission_comment_created(comment)
    @comment    = comment
    @submission = comment.commentable

    subject = "[mendicant-submission] #{@submission.assignment.name}: " +
              "#{@submission.user.name}"

    options = {
      :to      => to_from_submission(@submission, @comment.user.email, true),
      :subject => subject
    }

    unless @submission.assignment.course.cc_comments.blank?
      options[:cc] = @submission.assignment.course.cc_comments
    end

    mail(options)
  end

  def submission_updated(activity)
    @activity   = activity
    @submission = activity.actionable
    @user       = activity.user

    subject = "[mendicant-submission] #{@submission.assignment.name}: " +
              "#{@submission.user.name}"

    mail(:to      => to_from_submission(@submission, @user.email),
         :subject => subject)
  end
end
