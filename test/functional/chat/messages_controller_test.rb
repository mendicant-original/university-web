require 'test_helper'

class Chat::MessagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @channel_one = Factory(:chat_channel, :public => true, :name => 'Channel One')
    @channel_two = Factory(:chat_channel, :public => true, :name => 'Channel Two')
    Factory(:chat_message, :body => 'Channel One result', :channel => @channel_one)
    Factory(:chat_message, :body => 'Channel Two result', :channel => @channel_two)
  end

  test 'search scopes the results to the given channel only' do
    get :search, :channel => @channel_one.name, :search => 'result'

    assert_response :success
    assert_select 'h3', /1/
    assert_select 'tr', { :text => /One/, :count => 1 }
    assert_select 'tr', { :text => /Two/, :count => 0 }
  end

  test 'groups messages from one user under the same name' do
    @handle = Factory(:chat_handle, :name => 'Josh')
    Factory(:chat_message, :channel => @channel_one, :handle => @handle, :body => 'A')
    Factory(:chat_message, :channel => @channel_one, :handle => @handle, :body => 'B')
    Factory(:chat_message, :channel => @channel_one, :handle => @handle, :body => 'C')
    Factory(:chat_message, :channel => @channel_one, :body => 'Gibberish')
    Factory(:chat_message, :channel => @channel_one, :handle => @handle, :body => 'D')

    get :index, :channel => @channel_one.name

    assert_response :success
    assert_select 'tr', { :text => /#{@handle.name}/, :count => 2 }
  end
end
