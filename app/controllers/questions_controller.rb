class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  respond_to :html, :js

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = current_user.questions.new)
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def build_answer
    @answer = @question.answers.new
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/questions_item',
        locals: { question: @question }
      )
    )
  end
end
