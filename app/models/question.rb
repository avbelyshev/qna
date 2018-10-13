class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy


  validates :title, :body, presence: true

  scope :by_last_day, -> { where('created_at >= ?', 1.day.ago) }
end
