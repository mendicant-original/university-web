class AddOpenForEnrollmentFlagForCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :open_for_enrollment, :boolean
  end

  def self.down
    remove_column :courses, :open_for_enrollment
  end
end
