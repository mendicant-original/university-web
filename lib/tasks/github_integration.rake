namespace :github do

  desc "checks all submissions for new github commits"
  task :check_for_new_commits => :environment do
    Github::GithubHelper.check_for_new_commits
  end

  task :destroy_duplicates => :environment do
    commits = Assignment::Activity.where("description LIKE 'committed%'")

    initial_count = commits.count

    commits.each do |commit|
      similar_commits = Assignment::Activity.
        where(:description => commit.description, :created_at => commit.created_at).
        where("id <> #{commit.id}")

      similar_commits.destroy_all
    end

    final_count = commits.count

    puts "#{initial_count - final_count} / #{initial_count} duplicate records destroyed"
  end

end