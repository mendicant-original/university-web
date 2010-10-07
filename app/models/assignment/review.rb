class Assignment::Review < ActiveRecord::Base
  belongs_to :submission
  
  has_many :comments, :as => :commentable
  
  def course
    submission.assignment.course
  end
end
