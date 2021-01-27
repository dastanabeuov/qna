class AnswersController < ApplicationController
  include Voting

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
    @answers ||= Answer.all
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:success] = 'Your answer has been update!'
      @question = @answer.question
    else
      redirect_to question_path(@question)
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
    redirect_to question_path(@answer.question)
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
        attachments:  @answer.files,
        rating: @answer.vote_count,
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
    params.require(:answer).permit(:body, files: [], 
      links_attributes: [:id, :name, :url, :_destroy])
  end
end
