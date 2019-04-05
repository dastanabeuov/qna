class AnswersController < ApplicationController
  before_action :set_question, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question, notice: 'Answer was successfully created from: #{@question.title}!'
    else
      flash[:notice] = 'Your answer has not been published form: #{@question.title}!'
      render "questions/show"
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
