module Courses::AssignmentsHelper
  def activity_path(activity)
    id = activity.activity_id
    
    case activity.activity_type
      when "Comment" then review_path(Assignment::Review.find(Comment.find(id).commentable_id))
      when "Assignment::Review" then review_path(Assignment::Review.find(id))
    end
  end
  
  def assignment_path(assignment)
    course_assignment_path(assignment.course, assignment)
  end
end
