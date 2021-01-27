class QuestionsController < ApplicationController
  include Voting

  before_action :authenticate_user!, only: %i[new create show]
  before_action :load_question, only: %i[show edit update destroy]
  after_action :publish_question, only: [:create]

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
      flash[:success] = 'Your question has been update!'
    else
      render :edit
      flash[:error] = 'Your question has not been update!'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:success] = "Your question has been deleted."
    else 
      flash[:error] = "Your question has not been deleted."
    end
    redirect_to questions_path
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, success: 'Your question successfully created.'
    else
      flash[:error] = 'Your question not created.'
      render :new
    end
  end

  private

  def load_question
    @question ||= Question.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions-list',
      ApplicationController.render(
        partial: 'questions/question_item',
        locals: { question: @question }, layout: false
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
      links_attributes: [:id, :name, :url, :_destroy],
      award_attributes: [:id, :title, :image, :_destroy])
  end
end
