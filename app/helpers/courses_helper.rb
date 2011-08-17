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

end
