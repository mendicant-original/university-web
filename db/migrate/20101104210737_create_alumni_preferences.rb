class CreateAlumniPreferences < ActiveRecord::Migration
  def self.up
    create_table :alumni_preferences do |t|
      t.belongs_to :user
      t.boolean    :show_on_public_site
      t.boolean    :show_twitter
      t.boolean    :show_github
      t.boolean    :show_real_name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :alumni_preferences
  end
end
