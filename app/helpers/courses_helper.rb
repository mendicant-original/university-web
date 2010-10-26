module CoursesHelper
  def course_header(text="")
    if @review
      [
        link_to( @review.course.name, course_path(@review.course)),
        link_to( @assignment.name, course_assignment_path(@assignment.course, @assignment)),
        "Review"
      ].join(" > ").html_safe
    elsif @reviews
      [
        link_to( @assignment.course.name, course_path(@assignment.course)),
        link_to( @assignment.name, course_assignment_path(@assignment.course, @assignment)),
        "Reviews"
      ].join(" > ").html_safe
    elsif @assignment
      [
        link_to( @assignment.course.name, course_path(@assignment.course)),
        @assignment.name
      ].join(" > ").html_safe
    elsif @course
      link_to( @course.name, course_path(@course))
    end
  end

  def course_dates(course)
    duration = course.start_end
    if duration
      "#{duration.begin.strftime("%d %B %Y")} thru #{duration.end.strftime("%d %B %Y")}"
    else
      ''
    end
  end

end
