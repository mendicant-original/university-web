class AddHexColorToSubmissionStatus < ActiveRecord::Migration
  def self.up
    add_column :submission_statuses, :hex_color, :string
  end

  def self.down
    remove_column :submission_statuses, :hex_color
  end
end
