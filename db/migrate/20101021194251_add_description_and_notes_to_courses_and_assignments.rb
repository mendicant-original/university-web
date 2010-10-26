class AddDescriptionAndNotesToCoursesAndAssignments < ActiveRecord::Migration
  TABLES       = [:courses, :assignments]
  COLUMN_NAMES = [:description, :notes]
  def self.up
    TABLES.each do |table|
      COLUMN_NAMES.each do |column_name|
        add_column table, column_name, :text
      end
    end
  end

  def self.down
    TABLES.each do |table|
      COLUMN_NAMES.each do |column_name|
        remove_column table, column_name
      end
    end
  end
end
