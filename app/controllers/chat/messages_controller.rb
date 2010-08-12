class Chat::MessagesController < ApplicationController
  respond_to :json

  skip_before_filter :authenticate_user!, :only => [:create]
  skip_before_filter :change_password_if_needed, :only => [:create]
  before_filter :authenticate_service, :only => [:create]

  def index
    if params[:channel]
      if current_user.chat_channels.find_by_name(params[:channel])
        channel = params[:channel]
      else
        raise "No Access To This Channel or Invalid Channel!"
      end
    end
    
    if channel && params[:topic]
      topic = Chat::Channel.find_by_name(channel).topics.
                 find_by_name(params[:topic])
    end

    @messages = Chat::Message.includes(:channel).
                              where("chat_channels.name = ?", channel || "#rmu-general").
                              order("recorded_at DESC").
                              limit(200)
                              
    @messages = @messages.where(:topic_id => topic.id) if topic
    
    @messages.reverse!
  end
  
  def create
    message = JSON.parse(params[:message])
    
    channel = Chat::Channel.find_or_create_by_name(message["channel"])
    handle  = Chat::Handle.find_or_create_by_name(message["handle"])
    
    unless message["topic"].blank?
      topic_id = Chat::Topic.find_or_create_by_name_and_channel_id(
                   message["topic"], channel.id).id
    end
    
    chat_message = Chat::Message.create( :handle_id   => handle.id,
                                         :channel_id  => channel.id,
                                         :body        => message["body"],
                                         :recorded_at => message["recorded_at"],
                                         :topic_id    => topic_id)
                                       
    render :json => chat_message.to_json
  end
  
  def authenticate_service
    authenticate_or_request_with_http_basic do |id, password| 
      id == ENV['RMU_SERVICE_ID'] && password == ENV['RMU_SERVICE_PASS']
    end
  end
end
