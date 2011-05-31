Factory.define :comment do |f|
  f.commentable { Factory(:submission) }
  f.association :user
  f.comment_text "Lorem ipsum dolor sit amet"
end

