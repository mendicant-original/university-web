class Chat::Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :handle
  belongs_to :topic

  before_create :check_action

  def check_action
    regex = /^\u0001ACTION(.*)\u0001$/ 
    if body =~ regex
      self.body = body.match(regex).captures.first
      self.action = true
    end
  end
end
