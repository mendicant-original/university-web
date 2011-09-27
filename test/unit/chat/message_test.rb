require 'test_helper'

class Chat::MessageTest < ActiveSupport::TestCase
  context 'when created' do
    setup do
      @subject = Factory.build(:chat_message, :recorded_at => nil)
    end

    test 'require recorded_at field to be present' do
      assert ! @subject.valid?
    end
  end
end
