module CommentsHelper

  def link_to_comment(comment)
    link_to "comment ##{comment.index}", "##{comment.index}"
  end
end
