class Course < ActiveRecord::Base
  has_many :course_memberships, :dependent  => :destroy
  has_many :users,              :through    => :course_memberships
                                            
  has_many :course_documents                
  has_many :documents,          :through    => :course_documents
                                            
  has_many :assignments,        :dependent  => :destroy, 
                                :order      => "sort_order"

  belongs_to :channel,          :class_name => "Chat::Channel"
  belongs_to :term
  
  validates_presence_of   :name
  validates_uniqueness_of :name
  
  accepts_nested_attributes_for :assignments
  
  accepts_nested_attributes_for :course_memberships,
    :reject_if => proc { |attributes| attributes['user_id'].blank? },
    :allow_destroy => true
    
  accepts_nested_attributes_for :course_documents,
    :reject_if => proc { |attributes| attributes['document_id'].blank? },
    :allow_destroy => true
  
  scope :active,   where(:archived => false).order('start_date')
  scope :archived, where(:archived => true ).order('start_date')
  
  def students
    course_member_by_type('student')
  end
  
  def instructors
    course_member_by_type('instructor')
  end
  
  def mentors
    course_member_by_type('mentor')
  end
  
  def start_end
    if start_date.nil? or end_date.nil?
      nil
    else
      start_date..end_date
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
  
  def activities
    assignments.map { |a| a.recent_activities }.flatten.
    sort_by {|a| a.created_at }.reverse
  end
  
  private
  
  def course_member_by_type(type)
    User.includes(:course_memberships).
      where(["course_memberships.course_id = ? AND " + 
             "course_memberships.access_level = ?  ", id, type])
  end
end
