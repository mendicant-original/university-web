class GroupMailer < ActionMailer::Base
  default :from => "rmu.management@gmail.com"
  
  def mass_email(group_mail)
    @content = group_mail.content
    to_mails = group_mail.to.split(", ")
    mail(:to => to_mails, :cc => group_mail.cc, :bcc => group_mail.bcc,
         :subject => group_mail.subject)
  end
end
