class CommentsController < ApplicationController
  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    @comment.save
    if @commentable.class.name == 'Answer'
      redirect_to @commentable.question, notice: "Your comment posted!"
    else
      redirect_to @commentable, notice: 'Your comment posted!'
    end 
  end

  private
    def publish_comment
      return if @comment.errors.any?
      set_id
      ActionCable.server.broadcast "comments-for-#{@comment.commentable_type.underscore}-#{@id}",
          # ApplicationController.render(json: {comment: @comment, id: @comment.commentable_id })
          ApplicationController.render( plain: { comment: @comment, id: @comment.commentable_id }.to_json, content_type: 'application/json' )
    end

    def set_id
      if @comment.commentable_type == 'Question'
        @id = @comment.commentable_id
      else
        answer = Answer.find(@comment.commentable_id)
        @id = answer.question_id
      end
    end

    def comment_params
      params.require(:comment).permit(:text)
    end
end
