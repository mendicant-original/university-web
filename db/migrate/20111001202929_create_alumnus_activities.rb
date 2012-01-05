class CreateAlumnusActivities < ActiveRecord::Migration
  def self.up
    create_table :alumnus_activities do |t|
      t.belongs_to :user
      t.belongs_to :term

      t.string     :status

      t.timestamps
    end
  end

  def self.down
    drop_table :alumnus_activities
  end
end
