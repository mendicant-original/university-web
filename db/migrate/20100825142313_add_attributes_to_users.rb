class AddAttributesToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.text    :real_name
      t.text    :nickname
      t.text    :twitter_account_name
      t.text    :github_account_name
    end
  end

  def self.down
  end
end
