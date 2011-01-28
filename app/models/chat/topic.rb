class Chat::Topic < ActiveRecord::Base
  SORT_ORDERS = {
    'created_at' => { :name => 'Creation Date', :direction => 'desc'},
    'updated_at' => { :name => 'Last Updated' , :direction => 'desc'},
    'name'       => { :name => 'Alphabetical' , :direction => 'asc' }
  }

  belongs_to :channel
  has_many :messages

  scope :sort_order_by, lambda { |sort_order| 
    o = SORT_ORDERS[sort_order  ] ||
        SORT_ORDERS['created_at']

    order("#{SORT_ORDERS.key(o)} #{o[:direction]}")
  }
end
