class Chat::Channel < ActiveRecord::Base
  has_many :messages
  
  validates_uniqueness_of :name
  validates_presence_of   :name
  
  def recent(number_of_messages=5)
    messages.order("recorded_at DESC").limit(number_of_messages).reverse
  end
end
