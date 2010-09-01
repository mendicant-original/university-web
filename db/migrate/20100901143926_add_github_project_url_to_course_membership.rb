class AddGithubProjectUrlToCourseMembership < ActiveRecord::Migration
  def self.up
    add_column :course_memberships, :github_project_url, :text
  end

  def self.down
    remove_column :course_memberships, :github_project_url
  end
end
