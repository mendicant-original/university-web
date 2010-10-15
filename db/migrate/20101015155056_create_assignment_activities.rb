class CreateAssignmentActivities < ActiveRecord::Migration
  def self.up
    create_table :assignment_activities do |t|
      t.belongs_to :assignment
      t.belongs_to :submission
      t.belongs_to :user
      t.text       :description
      
      t.text       :activity_type
      t.integer    :activity_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assignment_activities
  end
end
