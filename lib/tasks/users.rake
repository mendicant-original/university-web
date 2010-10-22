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
  
  task :update_nickname => :environment do
    conditions = "(real_name = '' OR real_name IS NULL) AND (nickname = '' OR nickname IS NULL)"
    User.where(conditions).each do |missing_info_user|
      nickname = missing_info_user.email[/([^\@]*)@.*/,1]
      missing_info_user.nickname = nickname
      missing_info_user.save!
      puts [missing_info_user.email, nickname].join(': ')
    end
    
  end
end
