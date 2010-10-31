class CourseDocument < ActiveRecord::Base
  belongs_to :document
  belongs_to :course
end
