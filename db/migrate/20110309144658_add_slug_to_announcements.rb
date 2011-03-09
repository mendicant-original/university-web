class AddSlugToAnnouncements < ActiveRecord::Migration
  def self.up
    add_column :announcements, :slug, :string
  end

  def self.down
    remove_column :announcements, :slug
  end
end
