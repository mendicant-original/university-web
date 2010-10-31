class CreateCourseDocuments < ActiveRecord::Migration
  def self.up
    create_table :course_documents do |t|
      t.belongs_to :document
      t.belongs_to :course
      
      t.timestamps
    end
  end

  def self.down
    drop_table :course_documents
  end
end
