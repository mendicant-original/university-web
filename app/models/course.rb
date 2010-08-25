class Course < ActiveRecord::Base
  has_many :student_memberships
  has_many :students, :through => :student_memberships
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
