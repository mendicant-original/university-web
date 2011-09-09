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

end
