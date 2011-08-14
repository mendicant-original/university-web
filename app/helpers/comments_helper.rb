module CommentsHelper

  def link_to_comment(comment)
    link_to "#{comment.user.name}'s comment (##{comment.index})", "##{comment.index}"
  end
end
