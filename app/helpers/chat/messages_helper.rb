module Chat::MessagesHelper

  def last_message_timestamp_for_channel(channel)
    last_message_date = channel.last_message_date
    if last_message_date
      last_message_date.strftime("Last Message: %m/%d/%Y %I:%M%p")
    else
      'No Messages'
    end
  end

end
