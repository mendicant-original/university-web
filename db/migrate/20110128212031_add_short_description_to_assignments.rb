class AddShortDescriptionToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :short_description, :string
  end

  def self.down
    remove_column :assignments, :short_description
  end
end
