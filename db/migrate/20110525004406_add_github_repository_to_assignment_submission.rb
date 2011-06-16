class AddGithubRepositoryToAssignmentSubmission < ActiveRecord::Migration
  def self.up
    add_column :assignment_submissions, :github_repository, :string
  end

  def self.down
    remove_column :assignment_submissions, :github_repository
  end
end
