class QuestionsController < ApplicationController
  include Votes

  before_action :authenticate_user!, only: %i[new create show]
  before_action :set_question, only: %i[show edit update destroy]
  after_action :publish_question, only: [:create]

  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @answer = Answer.new
    @subscription = @question.subscriptions.where(user_id: current_user.id).first
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit; end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    respond_with(@question.destroy) if current_user.author_of?(@question)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with @question
  end

  private

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

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, 
      attachments: [],
      links_attributes: [:id, :name, :url, :_destroy],
      award_attributes: [:id, :title, :image, :_destroy])
  end
end
