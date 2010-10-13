class AddStartEndDateToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :start_date, :date
    add_column :courses, :end_date,   :date
  end

  def self.down
    remove_column :courses, :start_date
    remove_column :courses, :end_date
  end
end
