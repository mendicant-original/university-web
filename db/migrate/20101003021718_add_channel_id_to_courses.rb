class AddChannelIdToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :channel_id, :integer
  end

  def self.down
    remove_column :courses, :channel_id
  end
end
