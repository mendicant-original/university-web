class CreateAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :announcements do |t|
      t.boolean :public
      t.string  :title
      t.text    :body
      t.integer :author_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :announcements
  end
end
