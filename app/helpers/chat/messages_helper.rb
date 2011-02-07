module Chat::MessagesHelper

  def last_message_timestamp_for_channel(channel)
    last_message_date = channel.last_message_date
    if last_message_date
      last_message_date.strftime("Last Message: %m/%d/%Y %I:%M%p")
    else
      'No Messages'
    end
  end
  
  def message_date(message)    
    params[:last_date] = @since.to_date if @since && params[:last_date].nil?
    
    if params[:last_date].nil? || params[:last_date] != message.recorded_at.to_date
      params[:last_date] = message.recorded_at.to_date
      message.recorded_at.strftime("%A, %B %d, %Y")
    end
  end

  def message_time(message)
    message.recorded_at.strftime("%I:%M %p")
  end
end
