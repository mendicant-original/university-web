class Course < ActiveRecord::Base
  has_many :course_memberships, :dependent => :destroy
  has_many :students, :through => :course_memberships
  
  has_many :course_instructor_associations, :dependent  => :delete_all
  has_many :instructors, :through => :course_instructor_associations
  
  has_many   :assignments, :dependent  => :destroy
  belongs_to :channel, :class_name => "Chat::Channel"
  
  belongs_to :term
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  accepts_nested_attributes_for :assignments
  accepts_nested_attributes_for :course_instructor_associations,
    :reject_if => proc { |attributes| attributes['instructor_id'].blank? },
    :allow_destroy => true
    
  scope :active,   lambda { where(:archived => false).order('start_date') }
  scope :archived, lambda { where(:archived => true).order('start_date') }
  
  def start_end
    if start_date.nil? or end_date.nil?
      ""
    else
      "#{start_date.strftime("%d %B %Y")} thru #{end_date.strftime("%d %B %Y")}"
    end
  end
  
  def class_size
    students.count
  end
  
  def available_slots
    class_size_limit - class_size
  end
  
  def full?
    available_slots <= 0
  end
  
  def description_html
    RDiscount.new(description || "").to_html.html_safe
  end
end
