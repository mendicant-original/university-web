require 'octokit'

module Github
  class SubmissionCommitsFinder

    def initialize(options)
      @login  = options[:login]
      @client = Octokit::Client.new(options)
    end

    def find_and_store_new_commits

      Assignment::Submission.all_active.with_github_repository.each do |submission|
        begin
          find_and_store_new_commits_for_submission(submission)
        rescue Octokit::NotFound
          puts "Invalid Github Repository"

          submission.description ||= ""
          submission.description += %{\n\n**Invalid Github Repository**: #{submission.github_repository}}
          submission.github_repository = nil
          submission.save
        rescue Octokit::Forbidden
          puts "Too many requests"
          break
        end
      end

    end

    private

    def find_and_store_new_commits_for_submission(submission)

      puts "Looking for new commits in: #{submission.github_repository}"
      all_commits  = get_commits_across_branches(submission.github_repository)

      user_commits = all_commits.select do |commit|
        commit.login == submission.user.github_account_name &&
        ( submission.last_commit_time.nil? ||
          commit.commit_time > submission.last_commit_time )
      end.sort_by {|c| c.commit_time }

      if(user_commits.empty?)
        puts "No new commits."
        return
      end

      user_commits.each do |commit|
        submission.add_github_commit(commit)
        puts "Adding commit: #{commit.to_s}"
      end

    end

    def get_commits_across_branches(repository)
      @client.branches(repository).keys.inject([]) do |results, branch|
        results.concat(get_commits_for_branch(repository, branch))
      end
    end

    def get_commits_for_branch(repository, branch)
      begin
        @client.commits(repository, branch).map {|c| GithubCommit.new(c) }
      rescue
        #If this repo is a fork, branches will be returned by the Github API
        #that don't exist on this fork.
        []
      end
    end

  end
end