namespace :github do

  desc "checks all submissions for new github commits"
  task :check_for_new_commits => :environment do
    Github::GithubHelper.check_for_new_commits
  end

end