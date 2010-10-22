namespace :users do 
  
  task :import => :environment do
    File.foreach("#{RAILS_ROOT}/emails.txt") do |f|
      email = f.chomp
      
      unless User.find_by_email(email)
        User.create(:email => email, 
          :password => "rmu1337", 
          :password_confirmation => "rmu1337")
      end
    end
  end
  
  task :migrate_exams => :environment do
    exam_course = Course.find_by_name(ENTRANCE_EXAM_NAME)
    real_exam   = Exam.find_or_create_by_name(ENTRANCE_EXAM_NAME)
    
    exam_course.students.each do |student|
      status = exam_course.assignments.first.submission_for(student).status
      
      real_exam.exam_submissions.create(:user_id => student.id, 
                                        :url     => student.entrance_exam_url,
                                        :submission_status_id => status.id)
    end
  end
  
  task :update_nickname => :environment do
    conditions = "(real_name = '' OR real_name IS NULL) AND (nickname = '' OR nickname IS NULL)"
    User.where(conditions).each do |missing_info_user|
      nickname = missing_info_user.email[/([^\@]*)@.*/,1]
      missing_info_user.nickname = nickname
      missing_info_user.save!
    end
    
  end
end
