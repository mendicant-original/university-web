class Admissions::Submission < ActiveRecord::Base
  belongs_to :status, :class_name => "Admissions::Status"
  belongs_to :user
  belongs_to :course
  
  validates_presence_of :user_id
end
