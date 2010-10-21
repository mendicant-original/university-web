module Courses::Assignments::SubmissionsHelper
  def submission_path(submission)
    course_assignment_submission_path(submission.assignment.course, 
                                      submission.assignment,
                                      submission)
  end
  
  def new_submission_path(assignment)
    new_course_assignment_submission_path(assignment.course, assignment)
  end
  
  def submissions_path(assignment)
    course_assignment_submissions_path(assignment.course, assignment) 
  end
  
  def render_activity(activity)
    if Comment === activity.actionable
      render( :partial => "/comments/show", 
              :locals => { :comment => activity.actionable })
    elsif Assignment::Submission === activity.actionable
      render( :partial => "status_update", 
              :locals => { :activity => activity })
    end
  end
end
