class CreateExamSubmissions < ActiveRecord::Migration
  def self.up
    create_table :exam_submissions do |t|
      t.belongs_to :user
      t.belongs_to :exam
      t.belongs_to :submission_status
      t.string     :url
      
      t.timestamps
    end
  end

  def self.down
    drop_table :exam_submissions
  end
end
