class CreateChatHandles < ActiveRecord::Migration
  def self.up
    create_table :chat_handles do |t|
      t.text :name
      t.timestamps
    end
  end

  def self.down
    drop_table :chat_handles
  end
end
