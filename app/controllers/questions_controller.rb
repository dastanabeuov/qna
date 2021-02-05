class QuestionsController < ApplicationController
  include Votes

  before_action :authenticate_user!, only: %i[new create show]
  before_action :load_question, only: %i[show edit update destroy]
  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end  

  def edit
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      flash[:success] = 'Your question has been update!'
      redirect_to @question
    else
      redirect_to @question
      flash[:danger] = 'Your question has not been update!'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:success] = "Your question has been deleted."
      redirect_to questions_path
    end   
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question
      flash[:success] = 'Your question successfully created.'
    else
      render :new
      flash[:danger] = 'Your question is not created.'
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
    params.require(:question).permit(:title, :body, 
      attachments: [],
      links_attributes: [:id, :name, :url, :_destroy],
      award_attributes: [:id, :title, :image, :_destroy])
  end
end
