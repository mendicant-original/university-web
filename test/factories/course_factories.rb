Factory.sequence(:course_name) { |n| "Course #{n}" }

Factory.define :course do |u|
  u.name { |_| Factory.next(:course_name) }
end

Factory.define :course_membership do |u|
  u.association :course
  u.association :user
end
