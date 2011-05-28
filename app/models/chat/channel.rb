class Chat::Channel < ActiveRecord::Base
  has_many :messages,                 :dependent  => :destroy
  has_many :topics,                   :dependent  => :destroy
  has_many :chat_channel_memberships, :class_name => "Chat::ChannelMembership",
                                      :dependent  => :destroy

  validates_uniqueness_of :name
  validates_presence_of   :name

  scope :visible_on_dashboard, where(["chat_channel_memberships.visible_on_dashboard = ?", true])

  def recent(number_of_messages=2)
    messages.order("recorded_at DESC").limit(number_of_messages).reverse
  end

  def last_message_date
    messages.order("recorded_at DESC").first.try(:recorded_at)
  end

  def current_topic
    topics.joins(:meetings).where(:chat_meetings => { :ended_at => nil } ).first
  end
end
