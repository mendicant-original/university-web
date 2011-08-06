class RemoveRegistrationOpenFromTerm < ActiveRecord::Migration
  def self.up
    remove_column :terms, :registration_open
  end

  def self.down
    add_column :terms, :registration_open, :boolean, :default => false
  end
end
