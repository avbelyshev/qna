class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order(best: :desc, created_at: :asc) }

  def set_best!
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer.update!(best: false) if best_answer
      update!(best: true)
    end
  end
end
