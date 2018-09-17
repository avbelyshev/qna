class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :find_question, only: :create
  before_action :find_answer, only: [:update, :destroy, :set_best]
  after_action :publish_answer, only: :create

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def set_best
    @question = @answer.question
    @answer.set_best! if current_user.author_of?(@question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "answers_question_#{@question.id}",
      answer: @answer,
      attachments: @answer.attachments,
      rating: @answer.rating
    )
  end
end
