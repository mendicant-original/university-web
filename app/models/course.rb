class Course < ActiveRecord::Base
  has_many :course_memberships, :dependent => :destroy
  has_many :students, :through => :course_memberships
  
  has_many :course_instructor_associations, :dependent  => :delete_all
  has_many :instructors, :through => :course_instructor_associations
  
  has_many :assignments
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  accepts_nested_attributes_for :assignments
  accepts_nested_attributes_for :course_instructor_associations,
    :reject_if => proc { |attributes| attributes['instructor_id'].blank? },
    :allow_destroy => true
end
