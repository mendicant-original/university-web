class Exam < ActiveRecord::Base
  has_many :exam_submissions, :dependent => :delete_all
  has_many :users,            :through   => :exam_submissions
  belongs_to :term

  accepts_nested_attributes_for :exam_submissions
end
