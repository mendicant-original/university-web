class AddInactiveToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :inactive, :boolean, :default => false, :null => false
  end

  def self.down
    add_column :users, :inactive
  end
end
