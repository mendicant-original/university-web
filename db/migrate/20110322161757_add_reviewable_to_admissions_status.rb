class AddReviewableToAdmissionsStatus < ActiveRecord::Migration
  def self.up
    add_column :admissions_statuses, :reviewable, :boolean
  end

  def self.down
    remove_column :admissions_statuses, :reviewable
  end
end
