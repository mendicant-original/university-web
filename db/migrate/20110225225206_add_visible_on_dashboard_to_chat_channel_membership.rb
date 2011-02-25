class AddVisibleOnDashboardToChatChannelMembership < ActiveRecord::Migration
  def self.up
    add_column :chat_channel_memberships, :visible_on_dashboard, :boolean, :default => true

    Chat::ChannelMembership.update_all(:visible_on_dashboard => true)
  end

  def self.down
    remove_column :chat_channel_memberships, :visible_on_dashboard
  end
end
