Factory.sequence(:course_name) { |n| "Course #{n}" }

Factory.define :course do |u|
  u.name { |_| Factory.next(:course_name) }
  u.association :term
  u.description 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed
    do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad 
    minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip 
    ex ea commodo consequat. Duis aute irure dolor in reprehenderit in 
    voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint
    occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit 
    anim id est laborum.'
end

Factory.define :course_membership do |u|
  u.association  :course
  u.association  :user
  u.access_level "student"
end
