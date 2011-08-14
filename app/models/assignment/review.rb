class Assignment
  class Review < ActiveRecord::Base
    belongs_to :comment

    validates_presence_of :comment_id
  end
end
