class AnswersController < ApplicationController
  include Votes

  before_action :authenticate_user!, only: %i[new create]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy set_best]

  after_action :publish_answer, only: %i[create]

  respond_to :js, :json

  authorize_resource

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
    respond_with @answer
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with @answer
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to @answer.question
    flash[:success] = "Answer deleted!"
  end

  def set_best
    @question = @answer.question
    @answer.set_best if current_user.author_of?(@question)
  end

  private

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast "answers-for-question-#{@answer.question_id}", 
      {
        answer: @answer,
        attachments:  @answer.attachments,
        rating: @answer.voting,
        question_author: @answer.question.user_id
      }
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, 
      attachments: [], 
      links_attributes: [:id, :name, :url, :_destroy])
  end
end
