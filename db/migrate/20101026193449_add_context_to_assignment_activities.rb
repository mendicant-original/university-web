class AddContextToAssignmentActivities < ActiveRecord::Migration
  def self.up
    add_column :assignment_activities, :context, :text
  end

  def self.down
    remove_column :assignment_activities, :context
  end
end
