class Exam < ActiveRecord::Base
  has_many :exam_submissions, :dependent => :delete_all
  belongs_to :term
  
  accepts_nested_attributes_for :exam_submissions
end
