# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

user = User.create! :email => 'admin@mydomain.com', :access_level => 'admin', 
:nickname => 'Admin', :real_name => 'Site Administrator', 
:password => 'sesame', :password_confirmation => 'sesame'
