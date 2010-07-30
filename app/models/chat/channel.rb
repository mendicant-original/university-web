class Chat::Channel < ActiveRecord::Base
  has_many :messages
end
