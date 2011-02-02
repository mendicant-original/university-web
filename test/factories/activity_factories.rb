Factory.define :activity, :class => Assignment::Activity do |f|
  f.association :user
  f.description "made something"
end
