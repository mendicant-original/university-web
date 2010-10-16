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
  
  attr_protected :access_level, :alumni_number, :alumni_month, :alumni_year
  
  accepts_nested_attributes_for :course_memberships,
    :reject_if => proc { |attributes| attributes['course_id'].blank? },
    :allow_destroy => true
  
  accepts_nested_attributes_for :chat_channel_memberships,
    :reject_if => proc { |attributes| attributes['channel_id'].blank? },
    :allow_destroy => true
    
  has_many :exam_submissions, :dependent => :delete_all

  def self.search(search, page)
    sql_condition = %w(email real_name nickname twitter_account_name github_account_name).
                    map {|field| "#{field} LIKE :search"}.join(" OR ")
    paginate :per_page => 20, :page => page,
             :conditions => [sql_condition, {:search => "%#{search}%"}], :order => 'email'
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
  
  def gravatar_url(size=40)
    hash = Digest::MD5.hexdigest(email.downcase)
    
    "http://www.gravatar.com/avatar/#{hash}?s=#{size}"
  end
  
  def instructed_courses
    course_instructor_associations.map {|c| c.course }
  end
  
  def real_name_or_nick_name_required 
    if real_name.blank? and nickname.blank?
      errors.add(:base, 
                 "You need to provide either a real name or a nick name")
    end
  end
end
