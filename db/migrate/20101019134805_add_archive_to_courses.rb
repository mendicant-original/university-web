class AddArchiveToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :archived, :boolean, :default => true
  end

  def self.down
    remove_column :courses, :archived
  end
end
