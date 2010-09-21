class MoveIndividualProjectUrlFromCourseAssignments < ActiveRecord::Migration
  def self.up
    remove_column :course_memberships, :github_project_url
    add_column    :users,              :project_url,       :text
  end

  def self.down
    add_column    :course_memberships, :github_project_url, :text
    remove_column :users,              :project_url
  end
end
