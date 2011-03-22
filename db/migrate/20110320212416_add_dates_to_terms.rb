class AddDatesToTerms < ActiveRecord::Migration
  def self.up
    add_column :terms, :start_date, :date
    add_column :terms, :end_date, :date
  end

  def self.down
    remove_column :terms, :start_date
    remove_column :terms, :end_date
  end
end
