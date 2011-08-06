require 'test_helper'

class Chat::MessagesHelperTest < ActionView::TestCase
  include Chat::MessagesHelper

  context '#last_message_timestamp_for_channel' do

    context 'for a channel with no messages' do
      setup do
        @channel = Factory(:chat_channel)
      end

      test 'return "No Messages"' do
        assert_equal 'No Messages',
                     last_message_timestamp_for_channel(@channel)
      end
    end

    context 'for a channel with messages' do
      setup do
        @channel = Factory(:chat_channel)
        @recorded_at = 10.minutes.ago
        @channel.messages << Factory.build(
          :chat_message,
          :recorded_at => @recorded_at,
          :channel => @channel
        )
      end

      test 'return a meaningful "Last Message" notice' do
        timestamp = @recorded_at.strftime('%m/%d/%Y %I:%M%p')
        assert_equal "Last Message: #{timestamp}",
                     last_message_timestamp_for_channel(@channel)
      end
    end
  end
end
