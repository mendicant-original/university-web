require 'test_helper'

class Chat::MessagesControllerTest < ActionController::TestCase
  
  context "GET index" do
    tests Chat::MessagesController
    
    setup do
      @user = Factory(:confirmed_user)
      sign_in @user
      
      @default_channel = Factory(:chat_channel,
                                 :name => Chat::Channel::DEFAULT_CHANNEL)
      3.times { Factory(:chat_message, :channel => @default_channel) }
      
      @user.chat_channels << @default_channel
    end
    
    test "load messages from default channel if none provided" do
      get :index
      assert assigns(:messages).include?(@default_channel.messages.first)
    end
    
    test "raises an exception if channel is not on the current user list" do
      forbidden_channel = Factory(:chat_channel, :name => "#forbidden")
      assert_raise do
        get :index, :channel => forbidden_channel.name
      end
    end
    
    test "load messages from provided channel" do
      channel = Factory(:chat_channel, :name => "#channel")
      @user.chat_channels << channel
      
      3.times { Factory(:chat_message, :channel => channel) }
      
      get :index, :channel => channel.name
      assert assigns(:messages).include?(channel.messages.first)
    end
    
    test "load messages with provided topic" do
      topic = Factory(:chat_topic, :channel => @default_channel)
      7.times { Factory(:chat_message_with_topic, :topic => topic)}
      
      get :index, :channel => @default_channel.name, :topic => topic.name
      assert_equal topic, assigns(:messages).first.topic
      assert_equal topic.messages.count, assigns(:messages).count
    end
    
    test "with since param load only last messages" do
      old_message     = Factory(:chat_message, :channel => @default_channel,
                                :recorded_at => 10.minutes.ago)
      current_message = Factory(:chat_message, :channel => @default_channel,
                                :recorded_at => 5.minutes.ago)
      new_message     = Factory(:chat_message, :channel => @default_channel,
                                :recorded_at => 1.minute.ago)
      
      get :index, :since => current_message.recorded_at.to_s,
                  :last_id => current_message.id
      
      assert assigns(:messages).include?(new_message)
      assert !assigns(:messages).include?(current_message)
      assert !assigns(:messages).include?(old_message)
    end
  end
end
