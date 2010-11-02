Factory.define :chat_channel, :class => Chat::Channel do |c|
  c.name '#session-12'
end

Factory.define :chat_handle, :class => Chat::Handle do |h|
  h.name 'carl828x'
end

Factory.define :chat_topic, :class => Chat::Topic do |t|
  t.name 'testing'
  t.association :channel, :factory => :chat_channel
end

Factory.define :chat_message, :class => Chat::Message do |m|
  m.association :handle,  :factory => :chat_handle
  m.association :channel, :factory => :chat_channel
  m.recorded_at 3.minutes.ago
  m.body        "Could anyone take a look at this?"
end
