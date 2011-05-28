class Chat::MeetingsController < ApplicationController
  before_filter :authenticate_service
  skip_before_filter :authenticate_user!
  skip_before_filter :change_password_if_needed

  def index
    message = JSON.parse(params[:message])

    channel = Chat::Channel.find_or_create_by_name(message["channel"])
    if message["action"] == "start"
      if topic = channel.current_topic
        response = "'#{topic.name}' is already in progress. Cannot create a new discussion."
      else
        topic = Chat::Topic.find_or_create_by_name_and_channel_id(message["topic"], channel.id)

        if topic.current_meeting
          meeting = topic.current_meeting
          response = "'#{message['topic']}' is already in progress."
        else
          meeting = topic.meetings.create(:started_at => DateTime.now)
          response = "Created discussion '#{message['topic']}'"
        end
      end
    elsif message["action"] == "end"
      if topic = channel.current_topic
        meeting = topic.current_meeting
        meeting.ended_at = DateTime.now
        meeting.save!
        response = "Successfully ended discussion '#{topic.name}' at #{DateTime.now}"
      else
        response = "There is currently no discussion in progress in #{channel.name}"
      end
    elsif message["action"] == "current"
      if topic = channel.current_topic
        response = "'#{topic.name}' is currently in progress."
      else
        response = "There is currently no discussion in progress in #{channel.name}"
      end
    end

    render :json => {:text => response }
  end

  private

  def authenticate_service
    authenticate_or_request_with_http_basic do |id, password|
      id == RMU_SERVICE_ID && password == RMU_SERVICE_PASS
    end
  end
end
