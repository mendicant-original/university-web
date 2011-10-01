class User < ActiveRecord::Base
  after_create :add_public_channels_to_dashboard

  GITHUB_FORMAT = {
    :with        => /^(?!-)[a-z\d-]+/i,
    :message     => "can only contain alphanumeric characters and dashes.
                     Cannot start with a dash"
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

  validates_format_of   :email,
                        :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates_presence_of :real_name
  validates_presence_of :github_account_name

  has_many :chat_channel_memberships, :class_name => "Chat::ChannelMembership",
                                      :dependent  => :destroy
  has_many :chat_channels,            :through    => :chat_channel_memberships,
                                      :source     => :channel,
                                      :class_name => "Chat::Channel"
  has_many :course_memberships,       :dependent  => :destroy
  has_many :courses,                  :through    => :course_memberships
  has_many :assignment_submissions,   :class_name => "Assignment::Submission"
  has_many :comments,                 :as          => :commentable

  has_one  :admissions_submission,    :class_name => "Admissions::Submission",
                                      :dependent  => :destroy

  accepts_nested_attributes_for       :admissions_submission

  attr_protected :access_level, :alumni_number, :alumni_month, :alumni_year,
                 :inactive

  has_one                       :alumni_preferences
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

  scope :staff,    where(:access_level => "admin")
  scope :alumni,   where("alumni_number IS NOT NULL").order('alumni_number')
  scope :per_year, lambda { |year| where(:alumni_year => year) }

  def self.search(search, page, options={})
    sql_condition = %w(
      email real_name nickname twitter_account_name github_account_name
    ).map { |field| "#{field} ILIKE :search" }.join(" OR ")

    results = where([sql_condition, {:search => "%#{search}%"}])

    if options[:course_id] && !options[:course_id].blank?
      results = results.includes(:course_memberships).
        where(["course_memberships.course_id = ?", options[:course_id].to_i])
    end

    options[:sort]     ||= 'email'
    options[:per_page] ||= 20

    results.paginate :per_page => options[:per_page],
                     :page     => page,
                     :order    => options[:sort]
  end

  def self.random_password
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    chars.sample(8).join
  end

  # Retrieves locations for all users as an array of arrays where the inner
  # array is in the form [latitude, longitude].
  def self.locations
    where("latitude IS NOT NULL AND longitude IS NOT NULL").
      map { |u| [u.latitude, u.longitude] }
  end

  def access_level
    AccessLevel::User[read_attribute(:access_level)]
  end

  def github_repositories
    begin
      Octokit.repos(self.github_account_name).select do |repo|
        not repo.fork
      end.sort {|a, b| b.pushed_at <=> a.pushed_at }
    rescue # Octokit raises an 404 code exception when there this
           # github account name doesn't exist
      []
    end
  end


  def name
    if !real_name.blank?
      real_name
    elsif !nickname.blank?
      nickname
    else
      email[/([^\@]*)@.*/,1]
    end
  end

  def alumni_number=(number)
    if alumni_number.nil? and not number.blank?
      alumni_channel = Chat::Channel.find_by_name("#rmu-alumni")
      if alumni_channel
        alumni_channel_membership = chat_channel_memberships.
          find_by_channel_id(alumni_channel.id)

        if alumni_channel_membership.nil?
          chat_channel_memberships.create(:channel => alumni_channel)
        end
      end

      alumni_preferences = AlumniPreferences.create(:user_id => id)
    end

    write_attribute(:alumni_number, number)
  end

  def alumnus?
    !alumni_number.nil?
  end

  def staff?
    access_level.to_s == "admin"
  end

  # Returns a date object based on the alumni year and month
  # to be used for comparing with terms start and end dates
  def alumni_date
    alumnus? ? "#{alumni_year}-#{alumni_month}-1".to_date : nil
  end

  def gravatar_url(size=40)
    hash = Digest::MD5.hexdigest(email.downcase)

    "http://www.gravatar.com/avatar/#{hash}?s=#{size}&d=mm"
  end

  def instructor_courses
    course_by_membership_type("instructor")
  end

  def student_courses
    course_by_membership_type("student")
  end

  def mentor_courses
    course_by_membership_type("mentor")
  end

  def current_course_membership(course)
    course_memberships.where(:course_id => course.id).first
  end

  private

  def course_by_membership_type(type)
    Course.includes(:course_memberships).
      where(["course_memberships.user_id      = ? AND " +
             "course_memberships.access_level = ? ",
             id, type ]).
      order("start_date")
  end

  def real_name_or_nick_name_required
    if real_name.blank? and nickname.blank?
      errors.add(:base,
                 "You need to provide either a real name or a nick name")
    end
  end

  def add_public_channels_to_dashboard
    Chat::Channel.where(:public => true).each do |channel|
      chat_channel_memberships.find_or_create_by_channel_id(channel.id)
    end

    return true
  end

end
