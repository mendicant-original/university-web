class Term < ActiveRecord::Base
  has_many :courses
  has_many :exams
  
  has_many :waitlisted_students, :dependent => :destroy
  has_many :students,            :through   => :waitlisted_students
end
