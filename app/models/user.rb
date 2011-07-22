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

  validate              :real_name_or_nick_name_required
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

  attr_protected :access_level, :alumni_number, :alumni_month, :alumni_year

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

  scope :staff_and_alumni, order('alumni_number').
    where("access_level = 'admin' OR alumni_number IS NOT NULL")
  scope :staff,    where(:access_level => "admin")
  scope :alumni,   where("alumni_number IS NOT NULL").order('alumni_number')
  scope :per_year, lambda { |year| where(:alumni_year => year) }

  scope :publically_visible, joins(:alumni_preferences).
    where(['alumni_preferences.show_on_public_site = ?', true])

  def self.search(search, page, options={})
    sql_condition = %w(
      email real_name nickname twitter_account_name github_account_name
    ).map { |field| "#{field} ILIKE :search" }.join(" OR ")

    results = where([sql_condition, {:search => "%#{search}%"}])

    if options[:course_id] && !options[:course_id].blank?
      results = results.includes(:course_memberships).
        where(["course_memberships.course_id = ?", options[:course_id].to_i])
    end

    # TODO: sort_by will trigger the sql query, instead of using a relation.
    # The pagination would be created over the result array. Use a relation.
    if options[:sort]
      results = results.sort_by(&options[:sort])
    else
      results = results.order('email')
    end

    per_page = options[:per_page]
    per_page ||= 20

    results.paginate :per_page => per_page, :page => page
  end

  def self.random_password
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    (1..8).map { |a| chars[rand(chars.size)] }.join
  end

  # Returns a hash of lists of users at each lat, lng pair
  def self.locations
    where("latitude IS NOT NULL AND longitude IS NOT NULL").
      inject({}) do |h, user|
        h[user.latlng_key] ||= []
        h[user.latlng_key] << user.attributes_for_map
        h
      end
  end

  def latlng_key
    "#{ '%.5f' % latitude },#{ '%.5f' % longitude }"
  end

  # generate a hash of the data needed to populate a map marker info window
  def attributes_for_map
    attributes.slice('real_name', 'alumni_year').tap do |attrs|
      attrs['alumni_month'] = Date::MONTHNAMES[alumni_month] if alumni_month.present?
      attrs['staff']        = staff?
      attrs['ghash']        = gravatar_hash
      attrs['real_name']    = nickname if attrs['real_name'].blank? ||
                            ! alumni_preferences.try(:show_real_name)

      attrs['twitter_account_name'] = public_twitter_account_name
      attrs['github_account_name']  = public_github_account_name
    end
  end

  def public_twitter_account_name
    alumni_preferences.try(:show_twitter) && twitter_account_name.present? ?
      twitter_account_name : nil
  end

  def public_github_account_name
    alumni_preferences.try(:show_github) && github_account_name.present? ?
      github_account_name : nil
  end

  def staff?
    read_attribute(:access_level) == "admin"
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
    "http://www.gravatar.com/avatar/#{gravatar_hash}?s=#{size}&d=mm"
  end

  def gravatar_hash
    Digest::MD5.hexdigest(email.downcase)
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
