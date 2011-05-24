namespace :users do 

  desc 'import users from emails.txt, using a default password for each'
  task :import => :environment do
    File.foreach("#{RAILS_ROOT}/emails.txt") do |f|
      email = f.chomp
      unless User.find_by_email(email)
        user = User.create(:email          => email,
                    :nickname              => email.split('@')[0],
                    :password              => "rmu1337",
                    :password_confirmation => "rmu1337",
                    :github_account_name   => "fake_github_account")

        unless user.errors.empty?
          raise "Could not add user #{email}. Errors: #{user.errors}"
        end

        puts "Added: #{email}"
      end
    end
  end

  desc 'set nickname for all users lacking one'
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
