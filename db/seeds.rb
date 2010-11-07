User.destroy_all
Course.destroy_all
Term.destroy_all
Exam.destroy_all
Chat::Channel.destroy_all
SubmissionStatus.destroy_all

#######################
# Submission Statuses #
#######################

[ {:name => "Not Submitted", :sort_order => 0, :hex_color => "CCCCCC"},
  {:name => "Submitted",     :sort_order => 1, :hex_color => "DFB0FF"},
  {:name => "Approved",      :sort_order => 2, :hex_color => "00cc55"},
  {:name => "Declined",      :sort_order => 4, :hex_color => "FFCECE"}
].each {|s| SubmissionStatus.create(s) }


############
# Channels #
############

channel = Chat::Channel.create(:name => "rmu-rubyconf")

#########
# Terms #
#########

term = Term.create(:name => "2010", :registration_open => true)

#########
# Exams #
#########

exam = Exam.create(
  :name       => "RubyConf 2010", 
  :start_time => Time.now,
  :end_time   => Time.now,
  :term_id    => term.id
)

###########
# Courses #
###########

course = Course.create(:name => "RubyConf 101", :channel_id => channel.id,
  :start_date => Date.today, :end_date => Date.civil(2010, 11, 14), 
  :term_id => term.id, :class_size_limit => 10, :description => "RubyConf 2010",
  :notes => "*TODO* Add more notes ...")

###############
# Assignments #
###############

course.assignments.create(
  :name        => "r1-e1",
  :description => "Twitter bot + web service mashups",
  :notes       => "*TODO* Fill out notes"
)

course.assignments.create(
  :name        => "r1-e2",
  :description => "Implementing a Github themed achievement system",
  :notes       => "*TODO* Fill out notes"
)

course.assignments.create(
  :name        => "r1-e3",
  :description => "Building text based adventure games",
  :notes       => "*TODO* Fill out notes"
)

#########
# Users #
#########

me = User.create(:real_name => "Jordan Byron", :email => "jordan.byron@gmail.com", 
                 :password => "temp123", :password_confirmation => "temp123",
                 :twitter_account_name => "jordan_byron", 
                 :github_account_name => "jordanbyron")
me.update_attribute(:access_level, "admin")
me.update_attribute(:requires_password_change, false)

greg = User.create(:real_name => "Gregory Brown", 
                   :email => "gregory_brown@letterboxes.org",
                   :password => "temp123", :password_confirmation => "temp123",
                   :twitter_account_name => "seacreature", 
                   :github_account_name => "seacreature")

greg.update_attribute(:access_level, "admin")
greg.update_attribute(:requires_password_change, false)

course.course_memberships.create(:user_id => greg.id, :access_level => "instructor")

8.times do
  student_name = Faker::Name.name
  student = User.create(
    :real_name => student_name, 
    :email => Faker::Internet.email(student_name),
    :password => "temp123", :password_confirmation => "temp123"
  )

  student.update_attribute(:requires_password_change, false)
  
  student.course_memberships.create(:course_id => course.id, 
    :access_level => 'student')
end