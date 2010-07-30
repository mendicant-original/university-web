class CreateChatMessages < ActiveRecord::Migration
  def self.up
    create_table :chat_messages do |t|
      t.text :body
      t.datetime :recorded_at
      t.belongs_to :handle
      t.belongs_to :channel
    end
  end

  def self.down
    drop_table :chat_messages
  end
end
