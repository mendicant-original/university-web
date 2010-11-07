class TermsController < ApplicationController
  before_filter :find_term
  before_filter :allowed_students_only
  
  def registration 

  end
  
  def register
    course = Course.find(params[:course_id]) if params[:course_id]
    
    # TODO clean this up
    if course
      if @term.courses.include?(course) && !course.full?
        current_user.course_memberships.create(
          :course_id    => course.id, 
          :access_level => 'student'
        )
      
        flash[:notice] = "You have sucessfully enrolled in #{course.name}"
        redirect_to dashboard_path
      else
        flash[:error] = "#{course.name} is either full or not part of this term"
        redirect_to registration_path
      end
    elsif params[:wait_list]
      @term.waitlisted_students.create(:student_id => current_user.id)
      
      flash[:notice] = "You have sucessfully joined the #{@term.name} wait list"
      redirect_to dashboard_path
    end
  end
  
  private
  
  def find_term
    @term = Term.find(params[:id])
  end
  
  def allowed_students_only
    unless current_user.open_registrations.include? @term
      flash[:error] = "You are not authorized to register for this term"
      redirect_to dashboard_path
      return
    end
  end

end
