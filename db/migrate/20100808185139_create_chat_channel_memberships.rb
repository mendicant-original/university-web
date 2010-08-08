class CreateChatChannelMemberships < ActiveRecord::Migration
  def self.up
    create_table :chat_channel_memberships do |t|
      t.belongs_to :channel
      t.belongs_to :user
      t.timestamps
    end
  end

  def self.down
    drop_table :chat_channel_memberships
  end
end
