class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :question

  validates :body, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  after_create_commit :notify_subscribers

  def set_best!
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer.update!(best: false) if best_answer
      update!(best: true)
    end
  end

  private

  def notify_subscribers
    NewAnswerNotificationJob.perform_later(self)
  end
end
