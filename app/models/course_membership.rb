class CourseMembership < ActiveRecord::Base
  belongs_to :student, :class_name => "User", :foreign_key => "user_id"
  belongs_to :course
  
  validates_presence_of :course_id, :user_id
  validates_uniqueness_of :course_id, :scope => [:user_id]
end
