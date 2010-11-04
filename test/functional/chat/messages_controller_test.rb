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
    
    test "redirects to root if channel is not on the current user list" do
      forbidden_channel = Factory(:chat_channel, :name => "#forbidden")
      
      get :index, :channel => forbidden_channel.name
      assert_redirected_to root_path
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
    
    test "load only last messages if last received message is provided" do
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
    
    context "filtering results" do
      tests Chat::MessagesController
      
      setup do
        @oldest_message = Factory(:chat_message, :channel => @default_channel,
                                  :recorded_at => 5.hours.ago)
        @old_message    = Factory(:chat_message, :channel => @default_channel,
                                  :recorded_at => 3.hours.ago)
        @recent_message = Factory(:chat_message, :channel => @default_channel,
                                  :recorded_at => 30.minutes.ago)
      end
      
      test "with a 'from' time" do
        get :index, :commit => "Filter", :from => 1.hour.ago.to_s
        assert !assigns(:messages).include?(@oldest_message)
        assert !assigns(:messages).include?(@old_message)
        assert assigns(:messages).include?(@recent_message)
      end
      
      test "with a 'from' time and 'until' time of 'now'" do
        get :index, :commit => "Filter", :from => 1.hour.ago.to_s,
                                         :until => "now"
        assert !assigns(:messages).include?(@oldest_message)
        assert !assigns(:messages).include?(@old_message)
        assert assigns(:messages).include?(@recent_message)
      end
      
      test "with a 'until' time" do
        get :index, :commit => "Filter", :until => 1.hour.ago.to_s
        assert assigns(:messages).include?(@oldest_message)
        assert assigns(:messages).include?(@old_message)
        assert !assigns(:messages).include?(@recent_message)
      end
      
      test "with a 'until' time of 'now'" do
        get :index, :commit => "Filter", :until => "now"
        assert assigns(:messages).include?(@oldest_message)
        assert assigns(:messages).include?(@old_message)
        assert assigns(:messages).include?(@recent_message)
      end
      
      test "with both a 'from' and a 'until' time" do
        get :index, :commit => "Filter", :from  => 4.hours.ago.to_s,
                                         :until => 1.hour.ago.to_s
        assert !assigns(:messages).include?(@oldest_message)
        assert assigns(:messages).include?(@old_message)
        assert !assigns(:messages).include?(@recent_message)
      end
    end
  end
end
