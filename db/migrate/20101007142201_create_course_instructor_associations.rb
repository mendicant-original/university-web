class CreateCourseInstructorAssociations < ActiveRecord::Migration
  def self.up
    create_table :course_instructor_associations do |t|
      t.belongs_to :course
      t.belongs_to :instructor
      
      t.timestamps
    end
  end

  def self.down
    drop_table :course_instructor_associations
  end
end
