class Admissions::Status < ActiveRecord::Base

  def self.default
    find_or_create_by_name(:name => "Pending Review", 
      :sort_order => 0, :hex_color => "710F0A")
  end
  
  def self.received
    find_or_create_by_name(:name => "Received", 
      :sort_order => 1, :hex_color => "710F0A")
  end
end
