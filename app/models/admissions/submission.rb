class Admissions::Submission < ActiveRecord::Base
  belongs_to :status, :class_name => "Admissions::Status"
  belongs_to :user
  belongs_to :course
  
  has_many   :comments,   :as        => :commentable,
                          :dependent => :delete_all
  
  validates_presence_of :user_id
  
  def attachment=(file)
    
  end
  
  def attachment
    
  end
end
