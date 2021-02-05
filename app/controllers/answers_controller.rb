class AnswersController < ApplicationController
  include Votes

  before_action :authenticate_user!, only: %i[new create]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy set_best]

  after_action :publish_answer, only: %i[create]
  
  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
      flash[:success] = "Your answer has been created!"
    else
      redirect_to @question
      flash[:danger] = "Your answer has not created!"
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:success] = 'Your answer has been update!'
      redirect_to @answer.question
    else
      redirect_to @answer.question
      flash[:danger] = 'Your answer has not been update!'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question
      flash[:info] = 'Your answer has been deleted.'
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
