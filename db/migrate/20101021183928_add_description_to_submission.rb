class AddDescriptionToSubmission < ActiveRecord::Migration
  def self.up
    add_column :assignment_submissions, :description, :text
  end

  def self.down
    remove_column :assignment_submissions, :description
  end
end
