class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: [:edit, :destroy]

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user
    if @answer.save
      redirect_to @question, notice: 'Answer was successfully created!'
    else
      flash[:notice] = 'Your answer has not been published!'
      render "questions/show"
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
