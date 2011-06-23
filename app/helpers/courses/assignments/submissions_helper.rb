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
    elsif activity.is_a_github_commit?
      render( :partial => "github_commit",
              :locals => { :activity => activity })
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

  def github_link(github_repo)
    if github_repo
      link_to github_repo,
              "https://github.com/#{github_repo}",
              :target => "_blank"
    else
      %{<div id=github_help_text>
          Click 'Edit' to associate this submission with a github repository.
          You may enter the full repository URL or just its name.
        </div>}.html_safe
    end
  end

  def github_commit_link(activity)
    full_commit = github_commit_id(activity)
    "https://github.com/#{activity.actionable.github_repository}/commit/#{full_commit}"
  end

  def github_commit_id(activity, short=false)
    full_commit = activity.context.split('-')[0]

    if short
      full_commit[0..7]
    else
      full_commit
    end
  end

end
