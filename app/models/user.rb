class User < ActiveRecord::Base
  GITHUB_FORMAT = { 
    :with        => /^(?!-)[a-z\d-]+/i,
    :message     => "can only contain alphanumeric characters and dashes. 
                     Cannot start with a dash",
    :allow_blank => true 
  }

  TWITTER_FORMAT = { 
    :with        => /^\w+$/, 
    :message     => "can only contain letters, numbers or underscores.",
    :allow_blank => true 
  }
  
  devise :database_authenticatable, :validatable
  
  validates :twitter_account_name, :length => { :maximum => 15 },
                                   :format => TWITTER_FORMAT
                                                  
  validates :github_account_name,  :length => { :maximum => 40 },
                                   :format => GITHUB_FORMAT 
                                  
  validate :real_name_or_nick_name_required
  
  has_many :chat_channel_memberships, :class_name => "Chat::ChannelMembership"
  has_many :chat_channels,            :through    => :chat_channel_memberships, 
                                      :source     => :channel, 
                                      :class_name => "Chat::Channel"

  has_many :course_memberships,       :dependent  => :destroy
  has_many :courses,                  :through    => :course_memberships
  
  has_many :assignment_submissions,   :class_name => "Assignment::Submission"
  
  has_many :course_instructor_associations, :foreign_key => "instructor_id"
  has_many :comments,                       :as          => :commentable
  
  attr_protected :access_level, :alumni_number, :alumni_month, :alumni_year
  
  has_one :alumni_preferences
  
  accepts_nested_attributes_for :alumni_preferences
  
  accepts_nested_attributes_for :course_memberships,
    :reject_if => proc { |attributes| attributes['course_id'].blank? },
    :allow_destroy => true
  
  accepts_nested_attributes_for :chat_channel_memberships,
    :reject_if => proc { |attributes| attributes['channel_id'].blank? },
    :allow_destroy => true
    
  accepts_nested_attributes_for :comments,
    :reject_if => proc { |attributes| attributes['comment_text'].blank? },
    :allow_destroy => true
    
  has_many :exam_submissions, :dependent => :delete_all
  has_many :exams,            :through => :exam_submissions

  def self.search(search, page)
    sql_condition = %w(email real_name nickname twitter_account_name github_account_name).
                    map {|field| "#{field} LIKE :search"}.join(" OR ")

    paginate :per_page => 20, :page => page,
             :conditions => [sql_condition, {:search => "%#{search}%"}], 
             :order => 'email'
  end

  def self.random_password
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    (1..8).map { |a| chars[rand(chars.size)] }.join
  end
  
  def access_level
    AccessLevel::User[read_attribute(:access_level)]
  end
  
  def name
    if !nickname.blank?
      nickname
    elsif !real_name.blank?
      real_name
    else
      email[/([^\@]*)@.*/,1]
    end
  end

  def alumni_number=(number)
    if alumni_number.nil? and not number.blank?
      alumni_channel = Chat::Channel.find_by_name("#rmu-alumni")
      alumni_channel_membership = chat_channel_memberships.find_by_channel_id(alumni_channel.id)

      if alumni_channel_membership.nil?
        chat_channel_memberships.create(:channel => alumni_channel)
      end
    end    

    write_attribute(:alumni_number, number)
  end
  
  def alumnus?
    !alumni_number.nil?
  end
  
  def gravatar_url(size=40)
    hash = Digest::MD5.hexdigest(email.downcase)
    
    "http://www.gravatar.com/avatar/#{hash}?s=#{size}&d=mm"
  end
  
  def instructed_courses
    ids = course_memberships.where(:access_level => 'instructor').
      map(&:course_id)
    
    Course.where(:id => ids).order("start_date")
  end
  
  def real_name_or_nick_name_required 
    if real_name.blank? and nickname.blank?
      errors.add(:base, 
                 "You need to provide either a real name or a nick name")
    end
  end
  
  # Returns all terms which are:
  # * Open for registration (Term#registration_open == true)
  # * User took an exam which was approved
  # * User isn't on the waitlist
  # * User isn't registered for a course
  #
  def open_registrations
    approved = SubmissionStatus.where(:name => "Approved").first
    
    terms = exam_submissions.where(:submission_status_id => approved).
    includes([:exam => :term]).
    where(["terms.registration_open = ?", true]).
    map { |e| e.exam.term }
    
    terms.reject do |t| 
      t.students.include?(self) || courses.where(:term_id => t.id).any?
    end
  end
end
