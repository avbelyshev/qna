class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create
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
    if current_user.author_of?(@answer)
      message = { notice: 'The answer is successfully deleted.' }
      @answer.destroy
    else
      message = { alert: 'You can not delete this answer.' }
    end

    redirect_to @answer.question, message
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
