class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.belongs_to :course
      t.text       :name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
