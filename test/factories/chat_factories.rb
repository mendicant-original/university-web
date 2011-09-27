Factory.define :chat_channel, :class => Chat::Channel do |c|
  c.name '#session-12'
end

Factory.define :chat_handle, :class => Chat::Handle do |h|
  h.name 'carl828x'
end

Factory.define :chat_topic, :class => Chat::Topic do |t|
  t.name 'testing'
  t.channel { |_| Factory(:chat_channel) }
end

Factory.define :chat_message, :class => Chat::Message do |m|
  m.topic   { |message|
    Factory(:chat_topic, :channel => message.channel)
  }
  m.handle  { |_| Factory(:chat_handle) }
  m.recorded_at { |_| 3.minutes.ago }
  m.body "Could anyone take a look at this?"
end
