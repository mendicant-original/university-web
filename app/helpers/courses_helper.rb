module CoursesHelper
  def course_dates(course)
    duration = course.start_end
    if duration
      "#{duration.begin.strftime("%d %B %Y")} thru #{duration.end.strftime("%d %B %Y")}"
    else
      ''
    end
  end
end
