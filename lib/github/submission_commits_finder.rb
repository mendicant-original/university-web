require 'octokit'

module Github
  class SubmissionCommitsFinder

    def initialize(options)
      @login  = options[:login]
      @client = Octokit::Client.new(options)
    end

    def find_and_store_new_commits

      Assignment::Submission.with_github_repository.each do |submission|
        find_and_store_new_commits_for_submission(submission)
      end

    end

    private

    def find_and_store_new_commits_for_submission(submission)

      puts "Looking for new commits in: #{submission.github_repository}"
      all_commits  = @client.commits(submission.github_repository).map do |c|
        GithubCommit.new(c)
      end

      user_commits = all_commits.select do |commit|
        commit.login == @login &&
        commit.commit_time > submission.last_commit_time
      end

      if(user_commits.empty?)
        puts "No new commits."
        return
      end

      user_commits.each do |commit|
        submission.add_github_commit(commit)
        puts "Adding commit: #{commit.to_s}"
      end

    end

  end
end