class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable
  has_many :chat_channel_memberships, :class_name => "Chat::ChannelMembership"
  has_many :chat_channels, :through => :chat_channel_memberships, :source => :channel, :class_name => "Chat::Channel"
end
