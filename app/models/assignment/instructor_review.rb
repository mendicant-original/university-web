class Assignment
  class InstructorReview < Review
    belongs_to :assigned, :class_name => User
  end
end
