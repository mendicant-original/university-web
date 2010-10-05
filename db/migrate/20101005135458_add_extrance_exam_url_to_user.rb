class AddExtranceExamUrlToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :entrance_exam_url, :string
  end

  def self.down
    remove_column :users, :entrance_exam_url
  end
end
