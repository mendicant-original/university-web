class CommentsController < ApplicationController
  before_filter :find_comment,     :only => [:show, :update, :destroy]
  before_filter :commentator_only, :only => [:show, :update, :destroy]

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

  def commentator_only
    raise "Access Denied" if @comment.user != current_user
  end

end
