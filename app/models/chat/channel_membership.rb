module Chat
  class ChannelMembership < ActiveRecord::Base
    belongs_to :user
    belongs_to :channel
  end
end
