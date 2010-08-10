class AddTopicIdToMessages < ActiveRecord::Migration
  def self.up
    add_column :chat_messages, :topic_id, :integer
  end

  def self.down
    remove_column :chat_messages, :topic_id
  end
end
