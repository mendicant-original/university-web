class CommentsController < ApplicationController
  before_filter :find_comment,     :only => [:show, :update, :destroy]
  before_filter :comment_viewer_only, :only => [:show]
  before_filter :commentator_only, :only => [:update, :destroy]

  def show
    render :text => @comment.comment_text
  end

  def update
    @comment.update_attribute(:comment_text, params[:value])

    respond_to do |format|
      format.text
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def comment_viewer_only
    raise "Access Denied" unless @comment.user == current_user || (
      @comment.commentable.is_a?(Assignment::Submission) &&
      @comment.commentable.assignment.course.users.include?(current_user)
    )
  end

  def commentator_only
    raise "Access Denied" if @comment.user != current_user
  end

end
