class AddAccessLevelToCourseMemberships < ActiveRecord::Migration
  def self.up
    add_column :course_memberships, :access_level, :string
  end

  def self.down
    remove_column :course_memberships, :access_level
  end
end
