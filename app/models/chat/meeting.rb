class Chat::Meeting < ActiveRecord::Base
  belongs_to :topic

  validates_presence_of :started_at, :ended_at, :topic

  def messages
    Chat::Message.where(:channel_id => topic.channel_id).
      where("recorded_at >= ? AND recorded_at <= ?", started_at, ended_at)
  end
end
