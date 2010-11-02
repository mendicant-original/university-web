require 'test_helper'

class Chat::ChannelTest < ActiveSupport::TestCase

  context 'a Chat Channel' do

    setup do
      @subject = Factory(:chat_channel)
    end

    context 'with no messages' do
      should 'not have a last-message date' do
        assert_nil @subject.last_message_date
      end
    end

    context 'with some messages' do
      setup do
        3.times do
          @subject.messages << Factory.build(:chat_message,
                                             :channel => @channel)
        end
      end

      should 'have a last-message date' do
        assert_not_nil @subject.last_message_date
        assert @subject.last_message_date > 10.minutes.ago
      end
    end

  end

end
