class AddRequiresPasswordChangeToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :requires_password_change, :boolean, :default => true
  end

  def self.down
    remove_column :users, :requires_password_change
  end
end
