module Chat
  class Handle < ActiveRecord::Base
    has_many :messages
  end
end
