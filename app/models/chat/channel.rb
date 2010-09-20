class Chat::Channel < ActiveRecord::Base
  has_many :messages
  has_many :topics
  
  validates_uniqueness_of :name
  validates_presence_of   :name
  
  def recent(number_of_messages=5)
    messages.order("recorded_at DESC").limit(number_of_messages).reverse
  end
  
  def last_message_date
    message = messages.order("recorded_at DESC").first
    
    if message.nil?
      "No Messages"
    else
      message.recorded_at.strftime("Last Message: %m/%d/%Y %I:%M%p")
    end
  end
end
