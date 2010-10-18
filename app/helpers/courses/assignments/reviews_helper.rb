module Courses::Assignments::ReviewsHelper
  def review_path(review)
    course_assignment_review_path(review.course, 
                                  review.submission.assignment,
                                  review)
  end
  
  def new_review_path(assignment)
    new_course_assignment_review_path(assignment.course, assignment)
  end
  
  def reviews_path(assignment)
    course_assignment_reviews_path(assignment.course, assignment) 
  end
end
