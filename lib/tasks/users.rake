require 'csv'

namespace :users do

  desc 'import users from emails.txt, using a default password for each'
  task :import => :environment do
    CSV.foreach("#{RAILS_ROOT}/users.csv", headers: true) do |row|
      email          = row["email"]
      nickname       = row["nickname"]         || email.split('@')[0]
      password       = row["default_password"] || "rmu1337"
      github_account = row["github_account"]   || "fake_github_account"

      unless User.find_by_email(email)
        user = User.create(
            email:                 email,
            nickname:              nickname,
            password:              password,
            password_confirmation: password,
            github_account_name:   github_account
        )

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
