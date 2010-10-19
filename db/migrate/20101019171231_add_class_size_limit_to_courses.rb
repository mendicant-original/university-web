class AddClassSizeLimitToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :class_size_limit, :integer
  end

  def self.down
    remove_column :courses, :class_size_limit
  end
end
