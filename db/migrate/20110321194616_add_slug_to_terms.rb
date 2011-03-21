class AddSlugToTerms < ActiveRecord::Migration
  def self.up
    add_column :terms, :slug, :string
  end

  def self.down
    remove_column :terms, :slug
  end
end
