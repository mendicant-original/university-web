class AddLastCommitFieldsToAssignmentSubmission < ActiveRecord::Migration
  def self.up
    add_column :assignment_submissions,
               :last_commit_time,
               :datetime,
               :default => Time.parse("2011-01-01").utc,
               :null    => false

    add_column :assignment_submissions, :last_commit_id, :string
  end

  def self.down
    remove_column :assignment_submissions, :last_commit_id
    remove_column :assignment_submissions, :last_commit_time
  end
end
