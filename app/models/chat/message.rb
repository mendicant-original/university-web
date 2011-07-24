module Chat
  class Message < ActiveRecord::Base
    before_create :check_action

    belongs_to :channel
    belongs_to :handle
    belongs_to :topic

    def check_action
      regex = /^\u0001ACTION(.*)\u0001$/
      if body =~ regex
        self.body   = body.match(regex).captures.first
        self.action = true
      end
    end
    
    def nearby_messages(before = 2, after = 2)
      messages_before = Chat::Message.where("channel_id = ? and recorded_at < ?", channel_id, recorded_at)
      messages_after = Chat::Message.where("channel_id = ? and recorded_at > ?", channel_id, recorded_at)

      messages_before = messages_before.order("recorded_at DESC").limit(before).reverse
      messages_after = messages_after.limit(after)
      
      return [messages_before, self, messages_after].flatten
    end
  end
end
