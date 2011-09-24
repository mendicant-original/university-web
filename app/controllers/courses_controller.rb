class CoursesController < ApplicationController
  before_filter { @selected = :courses }
  before_filter :find_course, :only => [:show, :notes, :directory]
  before_filter :course_members_only, :only => [:show, :notes, :directory]

  def index
    @courses    = current_user.student_courses.archived
    @instructed = current_user.instructor_courses.archived
    @mentored   = current_user.mentor_courses.archived
  end

  def show
    @activities = @course.activities.paginate(:per_page => 10,
                                              :page     => params[:activity_page])

    @users = User.search(params[:search], params[:user_page],
      :sort => "course_memberships.access_level ASC",
      :course_id => @course.id, :per_page => 7)

    @grouped_users = @users.group_by do |user|
      user.current_course_membership(@course).access_level.to_s.humanize
    end

    @reviews = @course.reviews(current_user)

    respond_to do |format|
      format.html
      format.text { render :text => @course.notes }
    end
  end

  def notes
    @course.update_attribute(:notes, params[:value])

    respond_to do |format|
      format.text
    end
  end

  def search
    @course = Course.find(params[:id])
    search_key = params[:search]

    @results = Hash.new(0)

    @results[:course_description] = Course.search({description: search_key}, @course)

    @results[:notes] = Course.search({notes: search_key}, @course)

    @results[:assignments] = Assignment.search(search_key, @course.assignments)

    @results[:submission] = Assignment::Submission.search(search_key, @course.assignments.each.map {|a| a.submissions}.flatten)

    @results[:submission_comments] = []
    @results[:submission_comments]
    (@course.assignments.each.map &:submissions).flatten.each do |submission|
      @results[:submission_comments] << submission unless Comment.search(search_key, submission.comments).empty?
    end
                                                                                                
    if @course.channel
      @results[:irc_messages] = Chat::Message.search(search_key, @course.channel.messages)
    else                     
      @results[:irc_messages] = []
    end
  end

  def directory

  end

  private

  def find_course
    @course = Course.find(params[:id])
  end

  def course_members_only
    unless @course.users.include?(current_user)
      flash[:error] = "You are not enrolled in this course!"
      redirect_to courses_path
    end
  end
end
