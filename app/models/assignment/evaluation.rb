class Assignment
  class Evaluation < Review
    belongs_to :assigned, :class_name => "User"

    def to_s
      "Evaluation"
    end
  end
end
