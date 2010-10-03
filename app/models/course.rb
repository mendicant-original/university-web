class Course < ActiveRecord::Base
  has_many :course_memberships, :dependent => :destroy
  has_many :students, :through => :course_memberships
  has_many :assignments
  belongs_to :channel, :class_name => "Chat::Channel"
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  accepts_nested_attributes_for :assignments
end
