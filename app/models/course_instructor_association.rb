class CourseInstructorAssociation < ActiveRecord::Base
  belongs_to :instructor, :class_name => "User"
  belongs_to :course
end
