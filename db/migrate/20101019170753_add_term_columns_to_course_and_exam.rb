class AddTermColumnsToCourseAndExam < ActiveRecord::Migration
  def self.up
    add_column :courses, :term_id, :integer
    add_column :exams,   :term_id, :integer
  end

  def self.down
    remove_column :courses, :term_id
    remove_column :exams,   :term_id
  end
end
