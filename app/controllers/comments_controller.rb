class CommentsController < ActionController::Base
  before_action :authenticate_user!
  before_action :find_resource, only: :create
  before_action :find_comment, only: [:update, :destroy]

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def update
    @comment.update(comment_params) if current_user.author_of?(@comment)
  end

  def destroy
    @comment.destroy if current_user.author_of?(@comment)
  end

  private

  def find_resource
    return @resource = Answer.find(params[:answer_id]) if params[:answer_id]
    @resource = Question.find(params[:question_id]) if params[:question_id]
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
