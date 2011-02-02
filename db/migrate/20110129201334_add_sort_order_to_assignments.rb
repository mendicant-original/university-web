class AddSortOrderToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :sort_order, :integer
  end

  def self.down
    remove_column :assignments, :sort_order
  end
end
