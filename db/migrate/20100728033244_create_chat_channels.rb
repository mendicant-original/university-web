class CreateChatChannels < ActiveRecord::Migration
  def self.up
    create_table :chat_channels do |t|
      t.text :name
      t.timestamps
    end
  end

  def self.down
    drop_table :chat_channels
  end
end
