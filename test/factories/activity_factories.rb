Factory.sequence(:activity_description) { |n| "made something #{n} times" }

Factory.define :activity, :class => Assignment::Activity do |f|
  f.association :user
  f.description { |_| Factory.next(:activity_description) }
end
