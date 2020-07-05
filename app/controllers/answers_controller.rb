class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy correct_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    else
      render :edit
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer has been deleted.'
    else
      flash[:notice] = 'Your answer has not been deleted.'
    end
    redirect_to question_path(@answer.question)
  end

  def correct_best
    @answer.best_answer if current_user.author_of?(@answer)
  end  

  private

  def set_question
    @question ||= Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end  

  def answer_params
    params.require(:answer).permit(:body)
  end
end
