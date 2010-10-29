class GroupMailer < ActionMailer::Base
  default :from => "rmu.management@gmail.com"
  
  def mass_email(group_mail)
    @content = group_mail.content
    to_mails = group_mail.recipients.split(", ")
    mail(:to => "rmu.management@gmail.com", :bcc => to_mails,
         :subject => group_mail.subject)
  end
end
