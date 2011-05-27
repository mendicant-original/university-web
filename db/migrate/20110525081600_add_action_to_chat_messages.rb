class AddActionToChatMessages < ActiveRecord::Migration
  def self.up
    add_column :chat_messages, :action, :boolean
  end

  def self.down
    remove_column :chat_messages, :action
  end
end
