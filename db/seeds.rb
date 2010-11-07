User.destroy_all
Course.destroy_all
Term.destroy_all
Exam.destroy_all
Chat::Channel.destroy_all
SubmissionStatus.destroy_all
Document.destroy_all

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
general_channel = Chat::Channel.create(:name => "rmu-general")

############
# IRC Logs #
############

chatter_one   = Chat::Handle.create(:name => Faker::Internet.user_name)
chatter_two   = Chat::Handle.create(:name => Faker::Internet.user_name)
chatter_three = Chat::Handle.create(:name => Faker::Internet.user_name)

messages = [
  {:handle_id => chatter_one.id,   :body => "my guess is that the build tools have solidified"},
  {:handle_id => chatter_two.id,   :body => "yeah suppose so"},
  {:handle_id => chatter_three.id, :body => "yeah Gentoo is a rolling release, I'm still getting regular updates on my Gentoo install"},
  {:handle_id => chatter_one.id,   :body => "#{chatter_three.name}: yeah, but that's debian for you"},
  {:handle_id => chatter_one.id,   :body => "Truth be told, I'm loving the Arch approach to the point where I doubt I'll ever go back to a Debain or Redhat based distro for development anything"},
  {:handle_id => chatter_two.id,   :body => "I think I'm unusual though in that I'm willing to troubleshoot bugs in order to be constantly up-to-date, and not have to fight my distro for control"},
]

messages.each_with_index do |message, i|
  channel.messages.create(message.merge(:recorded_at => Time.now + i.minutes))
end

#########
# Terms #
#########

term = Term.create(:name => "Fall 2010", :registration_open => true)

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
  
Course.create(:name => "Advanced Ruby",
  :start_date => Date.today, :end_date => Date.civil(2010, 11, 14), 
  :term_id => term.id, :class_size_limit => 0)

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

#############
# Documents #
#############

Pathname.glob(File.join(Rails.root, 'db', 'seed_data', 'documents', '*.md')).each do |doc|
  Document.create(
    :title           => doc.basename.to_s.gsub('.md','').humanize,
    :body            => File.read(doc),
    :public_internal => true
  )
end

course.course_documents.create(:document_id => Document.first.id)

#########
# Users #
#########

me = User.create(:real_name => "Jordan Byron", :email => "jordan.byron@gmail.com", 
                 :password => "temp123", :password_confirmation => "temp123",
                 :twitter_account_name => "jordan_byron", 
                 :github_account_name => "jordanbyron")
me.update_attribute(:access_level, "admin")
me.update_attribute(:requires_password_change, false)

me.course_memberships.create(:course_id => course.id, :access_level => 'student')

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
    :email => Faker::Internet.free_email(student_name),
    :password => "temp123", :password_confirmation => "temp123",
    :twitter_account_name => Faker::Internet.user_name(student_name),
    :github_account_name  => Faker::Internet.user_name(student_name)
  )

  student.update_attribute(:requires_password_change, false)
  student.update_attribute(:access_level, 'student')
  student.course_memberships.create(:course_id => course.id, 
    :access_level => 'student')
end

#########################
# Activities / Comments #
#########################

course.assignments.each do |assignment|
  5.times do
    student   = course.students[rand(8)]
    commentor = (course.students + [greg])[rand(9)]
    
    submission = assignment.submission_for(student)
    
    submission.create_comment(
      :user_id      => commentor.id, 
      :comment_text => Faker::Lorem.paragraphs.join("\n\n")
    )
  end
end