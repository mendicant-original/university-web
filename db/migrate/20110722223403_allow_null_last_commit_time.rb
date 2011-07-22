class AllowNullLastCommitTime < ActiveRecord::Migration
  def self.up
    change_column :assignment_submissions, :last_commit_time, :datetime,
                  :null    => true,
                  :default => nil

  end

  def self.down
    change_column :assignment_submissions, :last_commit_time, :datetime,
                  :default => Time.parse("2011-01-01").utc,
                  :null    => false
  end
end
