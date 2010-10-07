class Exam < ActiveRecord::Base
  has_many :exam_submissions, :dependent => :delete_all
  
  accepts_nested_attributes_for :exam_submissions
end
