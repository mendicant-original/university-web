module Courses::Assignments::SubmissionsHelper
  def submission_path(submission, options={})
    course_assignment_submission_path(submission.assignment.course,
                                      submission.assignment,
                                      submission, options)
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
      render( :partial => "update",
              :locals => { :activity => activity })
    end
  end
  
  def comment_and_update_status
    button_to_function "Comment & Update Status",
    %{ $('form.new_comment #status').val($('#assignment_submission_submission_status_id').val());
       $('form.new_comment').submit()},
      :class => "gray"
  end
end
