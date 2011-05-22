class AddUserLocationInfo < ActiveRecord::Migration
  def self.up
    add_column :users, :location, :string
    add_column :users, :latitude, :decimal
    add_column :users, :longitude, :decimal
  end

  def self.down
    remove_column :users, :longitude
    remove_column :users, :latitude
    remove_column :users, :location
  end
end
