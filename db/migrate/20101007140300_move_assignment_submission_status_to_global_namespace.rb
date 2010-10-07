class MoveAssignmentSubmissionStatusToGlobalNamespace < ActiveRecord::Migration
  def self.up
    rename_table :assignment_submission_statuses, :submission_statuses    
  end

  def self.down
    rename_table :submission_statuses, :assignment_submission_statuses
  end
end
