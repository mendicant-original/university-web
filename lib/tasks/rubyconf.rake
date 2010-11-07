namespace :rubyconf do 

  desc 'Approve all exam submissions'
  task :approve => :environment do
    submission_status_id = SubmissionStatus.find_by_name("Approved").id
    ExamSubmission.update_all("submission_status_id = #{submission_status_id}")
  end
end





