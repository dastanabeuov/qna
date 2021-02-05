class CommentsController < ApplicationController
  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      set_redirect_success
    else
      set_redirect_danger
    end
  end

  def set_redirect_success
    if @commentable.is_a?(Answer)
      redirect_to @commentable.question
      flash[:success] = "Your Answer comment posted!"
    else
      redirect_to @commentable
      flash[:success] = 'Your Question comment posted!'
    end
  end

  def set_redirect_danger
    if @commentable.is_a?(Answer)
      redirect_to @commentable.question
      flash[:danger] = "Your Answer comment has not created!"
    else
      redirect_to @commentable
      flash[:danger] = "Your Question comment has not created!"
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
