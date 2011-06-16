class AddCcCommentsToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :cc_comments, :string
  end

  def self.down
    remove_column :courses, :cc_comments
  end
end
