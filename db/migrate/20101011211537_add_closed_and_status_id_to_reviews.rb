class AddClosedAndStatusIdToReviews < ActiveRecord::Migration
  def self.up
    add_column :assignment_reviews, :closed_date,          :datetime
    add_column :assignment_reviews, :closed_by_id,         :integer
    add_column :assignment_reviews, :submission_status_id, :integer
  end

  def self.down
    remove_column :assignment_reviews, :closed_date
    remove_column :assignment_reviews, :closed_by_id  
    remove_column :assignment_reviews, :submission_status_id
  end
end
