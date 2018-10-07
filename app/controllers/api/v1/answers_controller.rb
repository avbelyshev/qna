class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: :show
  skip_before_action :verify_authenticity_token, only: :create

  authorize_resource

  def index
    respond_with @question.answers
  end

  def show
    respond_with @answer
  end

  def create
    respond_with @question.answers.create(answer_params.merge(user: current_resource_owner))
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
