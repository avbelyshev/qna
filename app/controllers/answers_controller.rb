class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create, :destroy]
  before_action :find_answer, only: :destroy

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def destroy
    message = { notice: 'The answer is successfully deleted.' }
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      message = { alert: 'You can not delete this answer.' }
    end

    redirect_to @question, message
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
