class CreateChatMeetings < ActiveRecord::Migration
  def self.up
    create_table :chat_meetings do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :topic_id

      t.timestamps
    end
  end

  def self.down
    drop_table :chat_meetings
  end
end
