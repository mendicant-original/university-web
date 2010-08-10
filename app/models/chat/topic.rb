class Chat::Topic < ActiveRecord::Base
  belongs_to :channel
end
