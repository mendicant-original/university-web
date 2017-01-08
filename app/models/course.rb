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

  def submissions
    Assignment::Submission.where :assignment_id => assignments.map(&:id)
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

  def search(search_key)
    results = {}

    results[:course_description]  = Course.search({description: search_key}, self)
    results[:notes]               = Course.search({notes: search_key}, self)
    results[:assignments]         = search_assignments(search_key)
    results[:submissions]         = search_submissions(search_key)
    results[:submission_comments] = search_submission_comments(search_key)
    results[:irc_messages]        = search_irc_messages(search_key)

    results
  end

  private

  def course_member_by_type(type)
    User.includes(:course_memberships).
      where(["course_memberships.course_id = ? AND " +
            "course_memberships.access_level = ?  ", id, type])
  end

  def search_assignments(search_key)
    Assignment.search(search_key, assignments).where(:course_id => self.id)
  end

  def search_submissions(search_key)
    Assignment::Submission.search(search_key).
      where(:assignment_id => assignments)
  end

  def search_submission_comments(search_key)
    result = []

    submissions.each do |sub|
      result += Comment.search(search_key).
        where(:commentable_id => sub.id, :commentable_type => sub.class.to_s)
    end

    result
  end

  def search_irc_messages(search_key)
    result = []

    if channel && !channel.messages.empty?
      result = Chat::Message.search_within_channel(channel, {body: search_key})
    end

    result
  end

end
