class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, :body, presence: true

  scope :by_last_day, -> { where('created_at >= ?', 1.day.ago) }

  after_create_commit :subscribe_author

  private

  def subscribe_author
    subscriptions.create(user: user)
  end
end
