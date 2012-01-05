module Chat
  class Message < ActiveRecord::Base
    before_create :check_action

    belongs_to :channel
    belongs_to :handle
    belongs_to :topic

    def self.search_within_channel(channel, search_options)
      where(:channel_id => channel.id).search(search_options)
    end

    def check_action
      regex = /^\u0001ACTION(.*)\u0001$/
      if body =~ regex
        self.body   = body.match(regex).captures.first
        self.action = true
      end
    end
    
    def nearby_messages(before = 2, after = 2)
      msgs_before = Chat::Message.
        where("channel_id = ? and recorded_at <= ?", channel_id, recorded_at).
        where("id != ?", id)
        
      msgs_after = Chat::Message.
        where("channel_id = ? and recorded_at >= ?", channel_id, recorded_at).
        where("id != ?", id)
      msgs_before = msgs_before.order("recorded_at DESC").limit(before).reverse
      msgs_after = msgs_after.order("recorded_at ASC").limit(after)
      
      return [msgs_before, self, msgs_after].flatten
    end
  end
end
