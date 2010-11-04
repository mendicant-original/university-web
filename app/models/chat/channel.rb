class Chat::Channel < ActiveRecord::Base
  has_many :messages
  has_many :topics
  
  validates_uniqueness_of :name
  validates_presence_of   :name
  
  DEFAULT_CHANNEL = "#rmu-general"
  
  def recent(number_of_messages=2)
    messages.order("recorded_at DESC").limit(number_of_messages).reverse
  end
  
  def last_message_date
    messages.order("recorded_at DESC").first.try(:recorded_at)
  end
end
