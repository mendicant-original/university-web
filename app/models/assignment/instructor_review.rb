class Assignment
  class InstructorReview < Review
    belongs_to :assigned, :class_name => User

    def to_s
      "Instructor Review"
    end
  end
end
