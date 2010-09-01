class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable
  has_many :chat_channel_memberships, :class_name => "Chat::ChannelMembership"
  has_many :chat_channels, :through => :chat_channel_memberships, :source => :channel, :class_name => "Chat::Channel"

  has_many :course_memberships
  has_many :courses, :through => :course_memberships
  
  attr_protected :access_level
  
  accepts_nested_attributes_for :course_memberships,
    :reject_if => proc { |attributes| attributes['course_id'].blank? },
    :allow_destroy => true
  

  def self.search(search, page)
    paginate :per_page => 20, :page => page,
             :conditions => ['email LIKE ?', "%#{search}%"], :order => 'email'
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
      ""
    end
  end
end
