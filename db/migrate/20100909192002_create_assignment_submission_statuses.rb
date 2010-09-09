class CreateAssignmentSubmissionStatuses < ActiveRecord::Migration
  def self.up
    create_table :assignment_submission_statuses do |t|
      t.text    :name
      t.integer :sort_order
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assignment_submission_statuses
  end
end
