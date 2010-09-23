class CourseMembership < ActiveRecord::Base
  before_destroy :destory_assignment_submissions
  after_create   :create_assignment_submissions
  
  belongs_to :student, :class_name => "User", :foreign_key => "user_id"
  belongs_to :course
  
  validates_presence_of :course_id, :user_id
  validates_uniqueness_of :course_id, :scope => [:user_id]
  
  private
  
  def destory_assignment_submissions
    student.assignment_submissions.includes(:assignment).
      where(["assignments.course_id = ?", self.course_id]).each do |sub|
        sub.delete
      end
  end
  
  def create_assignment_submissions
    course.assignments.each do |assignment|
      assignment.submission_for(student)
    end
  end
end
