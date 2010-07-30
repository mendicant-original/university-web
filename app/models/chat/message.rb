class Chat::Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :handle
end
