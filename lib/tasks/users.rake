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
end