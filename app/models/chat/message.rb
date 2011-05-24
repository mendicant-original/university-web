class Chat::Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :handle
  belongs_to :topic

  def action?
    body.start_with?("\u0001ACTION")
  end

  def action
    body.gsub(/^\u0001ACTION(.*)\u0001$/, '\1')
  end
end
