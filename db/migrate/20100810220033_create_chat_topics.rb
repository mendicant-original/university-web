class CreateChatTopics < ActiveRecord::Migration
  def self.up
    create_table :chat_topics do |t|
      t.text       :name
      t.belongs_to :channel
      
      t.timestamps
    end
  end

  def self.down
    drop_table :chat_topics
  end
end
