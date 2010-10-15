class Course < ActiveRecord::Base
  has_many :course_memberships, :dependent => :destroy
  has_many :students, :through => :course_memberships
  
  has_many :course_instructor_associations, :dependent  => :delete_all
  has_many :instructors, :through => :course_instructor_associations
  
  has_many :assignments
  belongs_to :channel, :class_name => "Chat::Channel"
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  accepts_nested_attributes_for :assignments
  accepts_nested_attributes_for :course_instructor_associations,
    :reject_if => proc { |attributes| attributes['instructor_id'].blank? },
    :allow_destroy => true
    
  scope :active, lambda {
    where(["(start_date <= ? AND end_date >= ?) OR " +
           "(start_date IS ? AND end_date IS ?)", 
           Date.today, Date.today, nil, nil])
  }
  
  def start_end
    if start_date.nil? or end_date.nil?
      ""
    else
      "#{start_date.strftime("%d %B %Y")} thru #{end_date.strftime("%d %B %Y")}"
    end
  end
end
