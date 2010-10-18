class AddActionableToActivity < ActiveRecord::Migration
  def self.up
    rename_column :assignment_activities, :activity_type, :actionable_type
    rename_column :assignment_activities, :activity_id,   :actionable_id
  end

  def self.down
    rename_column :assignment_activities, :actionable_type, :activity_type
    rename_column :assignment_activities, :actionable_id,   :activity_id  
  end
end
