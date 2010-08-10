class Chat::Topic < ActiveRecord::Base
  belongs_to :channel
  has_many :messages
end
