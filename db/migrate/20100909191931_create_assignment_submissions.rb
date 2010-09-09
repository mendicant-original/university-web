class CreateAssignmentSubmissions < ActiveRecord::Migration
  def self.up
    create_table :assignment_submissions do |t|
      t.belongs_to :assignment
      t.belongs_to :user
      t.belongs_to :submission_status
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assignment_submissions
  end
end
