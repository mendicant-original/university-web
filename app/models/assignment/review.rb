class Assignment
  class Review < ActiveRecord::Base
    belongs_to :comment

    validates_presence_of :comment_id

    def self.current
      where(:closed => false).first
    end
  end
end
