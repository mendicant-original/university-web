class CreateAssignmentReviews < ActiveRecord::Migration
  def self.up
    create_table :assignment_reviews do |t|
      t.belongs_to :submission
      
      t.boolean    :closed,     :default => false
      t.text       :description
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assignment_reviews
  end
end
