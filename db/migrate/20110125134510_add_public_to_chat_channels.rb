class AddPublicToChatChannels < ActiveRecord::Migration
  def self.up
    add_column :chat_channels, :public, :boolean
  end

  def self.down
    remove_column :chat_channels, :public
  end
end
