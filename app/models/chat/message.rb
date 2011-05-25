class Chat::Message < ActiveRecord::Base  
  before_create :check_action
  
  belongs_to :channel
  belongs_to :handle
  belongs_to :topic

  def check_action
    regex = /^\u0001ACTION(.*)\u0001$/ 
    if body =~ regex
      self.body   = body.match(regex).captures.first
      self.action = true
    end
  end
end
