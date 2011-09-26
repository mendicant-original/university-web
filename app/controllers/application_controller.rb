class ApplicationController < ActionController::Base
  layout 'application'
  before_filter :authenticate_user!
  before_filter :change_password_if_needed
  before_filter :set_timezone
  before_filter :link_return

  helper_method :current_access_level

  private

  def change_password_if_needed
    authenticate_user! unless user_signed_in?

    if current_user.requires_password_change?
      render "users/change_password"
    end
  end

  def set_timezone
    if current_user && !current_user.time_zone.blank?
      Time.zone = current_user.time_zone
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    "/"
  end

  def after_sign_in_path_for(resource_or_scope)
    dashboard_path
  end

  def current_access_level
    return current_user.access_level if current_user && current_user.access_level
    AccessLevel::User["guest"]
  end
  
  # returns the person to either the original url from a redirect_away or to a default url
  def redirect_back(*params)
    uri = session.delete(:original_uri)
    
    if uri
      redirect_to uri
    else
      redirect_to(*params)
    end
  end

  # handles storing return links in the session
  def link_return
    session[:original_uri] = params[:return_uri] if params[:return_uri]
  end
  
  def admin_required
    unless current_access_level.allows?(:manage_users)
      flash[:error] = "Your account does not have access to this area"
      redirect_to dashboard_path
    end
  end
  
  def authenticate_service
    authenticate_or_request_with_http_basic do |id, password|
      id == RMU_SERVICE_ID && password == RMU_SERVICE_PASS
    end
  end
  
  def search_course_resources(search_key, course)
    results = Array.new
           
    # Course description
    Course.search({description: search_key}, course).each { |c|
      results << Result.new(
                  description: 'Course Description: ',
                  content: c.description)
      }                 
      
    # Course shared notes
    Course.search({notes: search_key}, course).each { |c|
      results << Result.new(
                  description: 'Shared Notes: ',
                  content: c.notes)
      
    }
    
    # Assigments
    Assignment.search(search_key, course.assignments).each do |assignment|
      results << Result.new(
        description: "Assignment( #{assignment.name} )",
        link: course_assignment_path(course, assignment))
    end
      
    # Submissions
    submissions = Assignment::Submission.search(
      search_key,
      course.assignments.each.map {|a| a.submissions}.flatten)

    submissions.each do |submission|
      results << Result.new(
      description:"#{submission.user.name}'s submission to #{submission.assignment.name} " ,
      link: course_assignment_submission_path(
        course,
        submission.assignment,
        submission))
    end
    
    # Submissions' comments
    (course.assignments.each.map &:submissions).flatten.each do |submission|
      Comment.search(search_key, submission.comments).each do |comment|
        results << Result.new(
          description: "Comment: #{comment.comment_text}",
          link: course_assignment_submission_path(
            course,
            comment.commentable.assignment,
            ))
      end
    end
    
    # IRC Log
    Chat::Message.search(search_key,
      course.channel.messages).each { |m| @results << Result.new(
        description: 'Irc Message', 
        content: m) } unless course.channel.nil?
    results
  end  
end
