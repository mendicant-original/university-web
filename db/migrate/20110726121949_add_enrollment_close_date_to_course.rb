class AddEnrollmentCloseDateToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :enrollment_close_date, :date
  end

  def self.down
    remove_column :courses, :enrollment_close_date
  end
end
