# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.email     "john@doe.com"
  user.password  "foobar"
end

Factory.define :course do |course|
  course.name    "Awesome Ruby Course"
end
