class CommentsController < ApplicationController
  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    @comment.save
    if @commentable.is_a?(Answer)
      redirect_to @commentable.question, notice: "Your comment posted!"
    else
      redirect_to @commentable, notice: 'Your comment posted!'
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast "comments-for-#{@comment.commentable_type.underscore}-#{@comment.commentable_id}",
        ApplicationController.render(json: {comment: @comment, id: @comment.commentable_id })
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
