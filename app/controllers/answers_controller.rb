class AnswersController < ApplicationController
  include Votes

  before_action :authenticate_user!, only: %i[new create]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy set_best]

  after_action :publish_answer, only: %i[create]
  
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:success] = 'Your answer has been update!'
    else
      flash[:error] = 'Your answer has not been update!'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer has been deleted.'
    else
      flash[:notice] = 'Your answer has not been deleted.'
    end
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
    params.require(:answer).permit(:body, attachments: [], 
      links_attributes: [:id, :name, :url, :_destroy])
  end
end
