class CreateAdmissionsSubmissions < ActiveRecord::Migration
  def self.up
    create_table :admissions_submissions do |t|
      t.belongs_to :user
      t.belongs_to :status
      t.belongs_to :course
      
      t.timestamps
    end
  end

  def self.down
    drop_table :admissions_submissions
  end
end
