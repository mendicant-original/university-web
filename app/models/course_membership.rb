class CourseMembership < ActiveRecord::Base
  before_destroy :destory_assignment_submissions, :destroy_channel_membership
  after_create   :create_assignment_submissions, :create_channel_membership
  
  belongs_to :student, :class_name => "User", :foreign_key => "user_id"
  belongs_to :course
  
  validates_presence_of :course_id #, :user_id
  validates_uniqueness_of :course_id, :scope => [:user_id]
  
  private
  
  def destory_assignment_submissions
    Assignment::Submission.where(:user_id => user_id).includes(:assignment).
      where(["assignments.course_id = ?", self.course_id]).each do |sub|
        sub.delete
      end
  end
  
  def destroy_channel_membership
    if course.channel
      channel_membership = student.chat_channel_memberships.where(["channel_id = ?", course.channel.id]).first
      channel_membership.destroy if channel_membership
    end
  end
  
  def create_assignment_submissions
    course.assignments.each do |assignment|
      assignment.submission_for(student)
    end
  end
  
  def create_channel_membership
    if course.channel && !student.chat_channels.include?(course.channel)
      Chat::ChannelMembership.create(:user => student, :channel => course.channel)
    end
  end
  
end
