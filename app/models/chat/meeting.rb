class Chat::Meeting < ActiveRecord::Base
  belongs_to :topic

  validates_presence_of :started_at, :ended_at, :topic
end
