class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent

  authorize_resource

  def create
    @comment = @parent.comments.create(comment_params)
  end

  private

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast "comments-for-#{@comment.commentable_type.underscore}-#{@comment.commentable_id}",
        ApplicationController.render(json: {comment: @comment, id: @comment.commentable_id })
  end

  def set_parent
    @parent = Question.find(params[:question_id]) if params[:question_id]
    @parent ||= Answer.find(params[:answer_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
