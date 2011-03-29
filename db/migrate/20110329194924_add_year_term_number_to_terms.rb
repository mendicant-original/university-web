class AddYearTermNumberToTerms < ActiveRecord::Migration
  def self.up
    add_column :terms, :year,   :integer
    add_column :terms, :number, :integer
  end

  def self.down
    remove_column :terms, :year
    remove_column :terms, :number
  end
end
