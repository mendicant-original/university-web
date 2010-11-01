namespace :courses do 

  desc 'migrate all course memberships to new access_level model'
  task :migrate => :environment do
    Course.all.each do |course|
      course.course_memberships.each do |cm|
        cm.update_attribute(:access_level, 'student')
      end
      
      CourseInstructorAssociation.where(:course_id => course.id).each do |instructor|
        cm = course.course_memberships.create(
          :user_id      => instructor.instructor_id,
          :access_level => 'instructor'
        )
      end
    end
  end
end
