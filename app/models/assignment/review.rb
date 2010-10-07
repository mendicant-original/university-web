class Assignment::Review < ActiveRecord::Base
  belongs_to :submission
  
  has_many :comments, :as => :commentable do    
    private
    
    def notify_users
      raise "Notifying!"
    end
  end
end
