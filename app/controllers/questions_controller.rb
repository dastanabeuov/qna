class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  include Voting

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_award
  end  

  def edit
    @question.links.new
    @question.build_award
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = "Your question has been deleted."
    else 
      flash[:notice] = "Your question has not been deleted."
    end
    redirect_to questions_path
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      flash[:error] = 'Your question not created.'
      render :new
    end
  end

  private

  def load_question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
      links_attributes: [:id, :name, :url, :_destroy],
      award_attributes: [:id, :title, :image, :_destroy])
  end
end
