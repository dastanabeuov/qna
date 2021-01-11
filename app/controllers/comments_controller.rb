class CommentsController < ApplicationController
  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    @comment.save
    if Answer.all.include?(@commentable)
      redirect_to @commentable.question, notice: "Your comment posted!"
    else
      redirect_to @commentable, notice: 'Your comment posted!'
    end 
  end

  private

    def comment_params
      params.require(:comment).permit(:text)
    end
end
