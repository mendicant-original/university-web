class Chat::Handle < ActiveRecord::Base
  has_many :messages
end
