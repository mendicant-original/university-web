module Courses::AssignmentsHelper
  def activity_path(activity)
    case activity.actionable
      when Comment then submission_path(activity.actionable.commentable)
      when Assignment::Submission then submission_path(activity.actionable)
    end
  end

  def assignment_path(assignment)
    course_assignment_path(assignment.course, assignment)
  end
end
