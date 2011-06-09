require 'octokit'

module Github
  module GithubHelper
    extend self

    CONFIG_FILE = "github.yml"

    def config(file = CONFIG_FILE)
      @config ||= parse_config(file)
    end

    def check_for_new_commits
      login_opts = {
          login: config["username"],
          token: config["api_token"],
      }

      SubmissionCommitsFinder.new(login_opts).find_and_store_new_commits
    end

    private

    def parse_config(file)
      filename = "#{::Rails.root.to_s}/config/#{file}"

      unless File.exists?(filename)
        raise "Could not read github integration config file."
      end

      YAML::load_file(filename)[::Rails.env]
    end

  end
end