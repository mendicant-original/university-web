class Announcement < ActiveRecord::Base
  belongs_to :author, :class_name => "User"

  validates_presence_of :title, :body

end
