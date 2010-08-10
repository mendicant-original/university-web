class Chat::Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :handle
  belongs_to :topic
end
