class Course < ActiveRecord::Base
  has_many :course_memberships, :dependent  => :destroy, :inverse_of => :course
  has_many :users,              :through    => :course_memberships

  has_many :course_documents
  has_many :documents,          :through    => :course_documents

  has_many :assignments,        :dependent  => :destroy,
                                :order      => "sort_order"

  belongs_to :channel,          :class_name => "Chat::Channel"
  belongs_to :term

  validates_presence_of   :name
  validates_presence_of   :term_id
  validates_uniqueness_of :name, :scope => :term_id

  validates_uniqueness_of :open_for_enrollment,   :if => "open_for_enrollment?"
  validates_presence_of   :enrollment_close_date, :if => "open_for_enrollment?"

  accepts_nested_attributes_for :assignments

  accepts_nested_attributes_for :course_memberships,
    :reject_if => proc { |attributes| attributes['user_id'].blank? },
    :allow_destroy => true

  accepts_nested_attributes_for :course_documents,
    :reject_if => proc { |attributes| attributes['document_id'].blank? },
    :allow_destroy => true

  scope :active,   where(:archived => false).order('start_date')
  scope :archived, where(:archived => true ).order('start_date')
  scope :current,  where(["start_date < ?", Date.today + 15.days])

  def self.current_course
    find_by_open_for_enrollment(true)
  end

  def students
    course_member_by_type('student')
  end

  def instructors
    course_member_by_type('instructor')
  end

  def mentors
    course_member_by_type('mentor')
  end

  def reviews(user=nil)
    reviews = Assignment::Review.includes(:submission => {:assignment => :course}).
      where("courses.id = ? and assignment_reviews.closed = ?", id, false).
      order("assignment_reviews.created_at DESC")

    if user
      if instructors.include?(user)
        reviews.order("type, assigned_id desc")
      else
        reviews.where("assignment_reviews.type = ? OR assignment_submissions.user_id = ?",
          "Assignment::Feedback", user.id).sort {|u| u == user ? 0 : 1 }
      end
    else
      reviews.where(:type => "Assignment::Feedback")
    end
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

  def full_name
    [term.try(:name), name].compact.join(" ")
  end

  def activities
    assignments.map { |a| a.recent_activities }.flatten.
      sort_by { |a| a.created_at }.reverse
  end                                     
  
  def search_course_resources(search_key)
    results = Hash.new()                    

    results[:course_description] = Course.search({description: search_key}, self)

    results[:notes] = Course.search({notes: search_key}, self)

    results[:assignments] = Assignment.search(search_key, self.assignments)

    results[:submission] = Assignment::Submission.search(search_key, self.assignments.each.map {|a| a.submissions}.flatten)

    results[:submission_comments] = []
    (self.assignments.each.map &:submissions).flatten.each do |submission|
      Comment.search(search_key, submission.comments).each do |comment|
        results[:submission_comments] << comment.commentable
      end      
    end    
                                                                                                
    if self.channel
      results[:irc_messages] = Chat::Message.search(search_key, self.channel.messages)
    else                     
      results[:irc_messages] = []
    end        
    results
  end
  
  private

  def course_member_by_type(type)
    User.includes(:course_memberships).
      where(["course_memberships.course_id = ? AND " +
             "course_memberships.access_level = ?  ", id, type])
  end
end
