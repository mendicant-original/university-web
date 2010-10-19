class CreateWaitlistedStudents < ActiveRecord::Migration
  def self.up
    create_table :waitlisted_students do |t|
      t.belongs_to :term
      t.belongs_to :student
      
      t.timestamps
    end
  end

  def self.down
    drop_table :waitlisted_students
  end
end
