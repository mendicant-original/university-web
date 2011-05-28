class Chat::MessagesController < ApplicationController
  respond_to :json

  before_filter      :find_channel,       :only  => [:index, :discussions, :discussion]
  skip_before_filter :authenticate_user!
  skip_before_filter :change_password_if_needed
  before_filter      :authenticate_service, :only => [:create, :discussion_topic_path]

  def index
    unless @channel
      flash[:error] = "Channel does not exist!"
      redirect_to dashboard_path
      return
    end

    change_password_if_needed unless @channel.public?

    if !@channel.public? && !(current_user && current_user.chat_channels.include?(@channel))
      flash[:error] = "You do not have access to this channel."
      redirect_to dashboard_path
      return
    end

    topic = @channel.topics.find_by_name(params[:topic]) if params[:topic]

    @messages = @channel.messages.order("recorded_at DESC")
    @messages = @messages.where(:topic_id => topic.id) if topic

    if params[:since] && !params[:since].blank?
      @since    = DateTime.parse(params[:since])
      @messages = @messages.where(["recorded_at > ? AND chat_messages.id <> ?",
                    @since, params[:last_id].to_i])
    else
      total_messages = @messages.count

      @messages = @messages.limit(params[:limit] || 200) unless params[:full_log]

      @more_messages = total_messages > @messages.length
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

  def discussions
    unless @channel
      flash[:error] = "Channel does not exist!"
      redirect_to dashboard_path
      return
    end

    change_password_if_needed unless @channel.public?

    if !@channel.public? && !(current_user && current_user.chat_channels.include?(@channel))
      flash[:error] = "You do not have access to this channel."
      redirect_to dashboard_path
      return
    end

    params[:sort] ||= 'created_at'
    @discussion_orders = Chat::Topic::SORT_ORDERS
    @discussions = @channel.topics.sort_order_by(params[:sort])
  end

  def discussion
    unless @channel
      flash[:error] = "Channel does not exist!"
      redirect_to dashboard_path
      return
    end

    change_password_if_needed unless @channel.public?

    if !@channel.public? && !(current_user && current_user.chat_channels.include?(@channel))
      flash[:error] = "You do not have access to this channel."
      redirect_to dashboard_path
      return
    end

    unless @discussion = @channel.topics.find_by_name(params[:topic])
      flash[:error] = "Discussion does not exist!"
      redirect_to dashboard_path
      return
    end

    @meetings = @discussion.meetings
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

  def discussion_topic_url
    channel = Chat::Channel.find_by_name(params[:channel])
    topic   = Chat::Topic.find_by_name(params[:topic])

    url  = chat_messages_url(:channel => channel.name, :topic => topic.name)

    render :text => url
  end

  def transcripts
    redirect_to chat_messages_path(:channel => '#' + params[:channel])
  end

  private

  def authenticate_service
    authenticate_or_request_with_http_basic do |id, password|
      id == RMU_SERVICE_ID && password == RMU_SERVICE_PASS
    end
  end

  def find_channel
    @channel = Chat::Channel.find_by_name(params[:channel])
  end
end
