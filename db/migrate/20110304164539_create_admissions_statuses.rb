class CreateAdmissionsStatuses < ActiveRecord::Migration
  def self.up
    create_table :admissions_statuses do |t|
      t.text    :name
      t.integer :sort_order
      t.string  :hex_color
      
      t.timestamps
    end
  end

  def self.down
    drop_table :admissions_statuses
  end
end
