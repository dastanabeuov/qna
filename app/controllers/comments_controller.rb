class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent

  respond_to :js
  
  authorize_resource

  def create
    @comment = @commentable.comments.create(comment_params)
    @comment.user = current_user
    @comment.save
    respond_with @comment
  end

  private

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast "comments-for-#{@comment.commentable_type.underscore}-#{@comment.commentable_id}",
        ApplicationController.render(json: {comment: @comment, id: @comment.commentable_id })
  end

  def set_parent
    @commentable = Question.find(params[:question_id]) if params[:question_id]
    @commentable ||= Answer.find(params[:answer_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
