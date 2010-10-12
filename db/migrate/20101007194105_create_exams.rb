class CreateExams < ActiveRecord::Migration
  def self.up
    create_table :exams do |t|
      t.string   :name
      t.datetime :start_time
      t.datetime :end_time
      
      t.timestamps
    end
  end

  def self.down
    drop_table :exams
  end
end
