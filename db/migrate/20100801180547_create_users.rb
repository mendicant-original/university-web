class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.database_authenticatable
      t.timestamps
      t.boolean :requires_password_change, :default => true
    end
  end

  def self.down
    drop_table :users
  end
end
