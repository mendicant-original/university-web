class AddAlumniFieldsToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :alumni_number
      t.integer :alumni_month
      t.integer :alumni_year
    end
  end

  def self.down
  end
end
