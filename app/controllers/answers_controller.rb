class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
