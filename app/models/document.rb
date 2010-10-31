class Document < ActiveRecord::Base
  has_many :course_documents
  has_many :courses, :through => :course_documents
  
  validates_presence_of :title, :body
end
