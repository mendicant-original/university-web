module CoursesHelper
  def course_dates(course)
    duration = course.start_end
    if duration
      "#{duration.begin.strftime("%d %B %Y")} thru #{duration.end.strftime("%d %B %Y")}"
    else
      ''
    end
  end

  def progress_report_students(course)
    students = course.students.to_a

    if students.include? current_user
      students.delete(current_user)
      students.insert(0, current_user)
    end

    students
  end

  def submission_status_class(submission)
    css_class = "status"

    if submission.current_review
      if Assignment::Feedback === submission.current_review ||
         submission.editable_by?(current_user)
        css_class << " review"
      end
    end

    css_class
  end

  def submission_status_style(submission)
    background   = submission_status_rgb_color(submission.status)
    border_color = submission_status_hex_color(submission.status)

    if Assignment::Evaluation === submission.current_review &&
       submission.editable_by?(current_user)
      border_color = "C81A12"
    end

    %{ background-color: rgba(#{background}, 0.15);
       border-color: ##{border_color};
     }
  end

  def highlighted_snippet(text, key, opts={})
    opts[:surround] ||= 30

    index = text.index(/#{key}/i)
    if index
      start = index - opts[:surround]
      start = 0 if start < 0

      prefix = start == 0 ? "" : "..."

      finish = index + key.length + opts[:surround]
      finish = -1 if finish >= text.length

      suffix = finish == -1 ? "" : "..."

      highlight prefix + text[start..finish] + suffix, key
    else
      text[0, opts[:surround] * 2]
    end
  end

  def submission_search_result(submission)
    link_text = submission.user.name + "'s submission for " + submission.assignment.name

    haml_tag :b do
      haml_concat(
        link_to link_text, course_assignment_submission_path(
          @course, submission.assignment, submission
        )
      )
    end

    haml_tag :br

    haml_tag '.context' do
      haml_concat highlighted_snippet(submission.description, @search_key)
    end
  end

  def submission_comment_search_result(comment)
    submission = comment.commentable
    link_text = 'A comment in ' +
      submission.user.name + "'s submission for " +
      submission.assignment.name

    haml_tag :b do
      haml_concat(
        link_to link_text, course_assignment_submission_path(
          @course, submission.assignment, submission
        )
      )
    end

    haml_tag :br

    haml_tag '.context' do
      haml_concat highlighted_snippet(comment.comment_text, @search_key)
    end
  end

end
