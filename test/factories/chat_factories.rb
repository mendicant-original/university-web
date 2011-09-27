Factory.sequence(:channel_name) { |n| "#session-#{n}" }
Factory.sequence(:chat_handle_name) { |n| "joe-#{n}" }
Factory.sequence(:message_body) { |n| "Hello World number #{n}" }

Factory.define :chat_channel, :class => Chat::Channel do |c|
  c.name { |_| Factory.next(:channel_name) }
end

Factory.define :chat_handle, :class => Chat::Handle do |h|
  h.name { |_| Factory.next(:chat_handle_name) }
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
  m.body { |_| Factory.next(:message_body) }
end
