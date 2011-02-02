Factory.define :submission, :class => Assignment::Submission do |f|
  f.association :assignment
  f.association :user
end
