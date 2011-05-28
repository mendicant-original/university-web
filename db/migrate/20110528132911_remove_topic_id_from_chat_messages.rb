class RemoveTopicIdFromChatMessages < ActiveRecord::Migration
  def self.up
    remove_column :chat_messages, :topic_id
  end

  def self.down
    add_column :chat_messages, :topic_id, :integer
  end
end
