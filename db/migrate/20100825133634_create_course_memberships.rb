class CreateCourseMemberships < ActiveRecord::Migration
  def self.up
    create_table :course_memberships do |t|
      t.belongs_to :user
      t.belongs_to :course

      t.timestamps
    end
  end

  def self.down
    drop_table :course_memberships
  end
end
