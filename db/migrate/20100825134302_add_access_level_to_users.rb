class AddAccessLevelToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :access_level, :string
  end

  def self.down
    remove_column :users, :access_level
  end
end
