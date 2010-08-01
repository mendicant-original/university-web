class Chat::MessagesController < ApplicationController
  respond_to :json

  skip_before_filter :authenticate_user!, :only => [:create]
  before_filter :authenticate_service, :only => [:create]

  def index
    @messages = Chat::Message.includes(:channel).
                              where("chat_channels.name = ?", "#rmu-general").
                              order(:recorded_at)
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
  
  def authenticate_service
    authenticate_or_request_with_http_basic do |id, password| 
      id == ENV['RMU_SERVICE_ID'] && password == ENV['RMU_SERVICE_PASS']
    end
  end
end
