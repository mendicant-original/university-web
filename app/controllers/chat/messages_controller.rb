class Chat::MessagesController < ApplicationController
  before_filter :authenticate, :only => [:index]
  
  def index
    @messages = Chat::Message.all(:order => "recorded_at DESC")
  end
  
  def create
    message = JSON.parse(params[:message])
    
    channel = Chat::Channel.find_or_create_by_name(message["channel"])
    handle  = Chat::Handle.find_or_create_by_name(message["handle"])
    
    chat_message = Chat::Message.create( :handle_id   => handle.id,
                                       :channel_id  => channel.id,
                                       :body        => message["body"],
                                       :recorded_at => message["recorded_at"])
                                       
    render :json => chat_message.to_json
  end
  
  private

  def authenticate
    authenticate_or_request_with_http_basic do |id, password| 
        id == "api" && password == "cows"
    end
  end
end
