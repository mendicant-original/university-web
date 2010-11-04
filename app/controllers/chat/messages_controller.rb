class Chat::MessagesController < ApplicationController
  respond_to :json

  skip_before_filter :authenticate_user!, :only => [:create]
  skip_before_filter :change_password_if_needed, :only => [:create]
  before_filter :authenticate_service, :only => [:create]

  def index
    params[:channel] ||= Chat::Channel::DEFAULT_CHANNEL
    channel = current_user.chat_channels.find_by_name(params[:channel])
    unless channel
      flash[:error] = "You don't have access or this channel is invalid."
      redirect_to(root_path) and return
    end
    
    topic = channel.topics.find_by_name(params[:topic]) if params[:topic]
    if topic
      @messages = topic.messages
    else
      @messages = channel.messages
    end

    @messages = @messages.order("recorded_at DESC")
    
    if params[:from] || (params[:until] && params[:until] != "now")
      filter_messages
    elsif params[:since]
      @messages = @messages.where(["recorded_at > ? AND chat_messages.id <> ?", 
                    Time.parse(params[:since]), params[:last_id].to_i])
    else
      @messages = @messages.limit(params[:limit] || 200) unless params[:full_log]
    end
    
    @messages.reverse!
    
    respond_to do |format|
      format.html
      format.json do
        json_messages = @messages.map do |message|
          {
            :body        => message.body,
            :handle      => message.handle.name,
            :recorded_at => message.recorded_at,
            :id          => message.id,
            :html        => render_to_string(:partial => 'display.html.haml', 
                              :locals => {:message => message})
          }
        end
        
        render :json => json_messages.to_json
      end
    end
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
      id == RMU_SERVICE_ID && password == RMU_SERVICE_PASS
    end
  end
  
  private
  def filter_messages
    if params[:from] && params[:until] && params[:until] != "now"
      @messages = @messages.where :recorded_at =>
          Time.parse(params[:from])..Time.parse(params[:until])
      
    elsif params[:until] && params[:until] != "now"
      @messages = @messages.where ["recorded_at < ?",
                                   Time.parse(params[:until])]
      
    elsif params[:from]
      @messages = @messages.where ["recorded_at > ?",
                                   Time.parse(params[:from])]
    end
  end
end
