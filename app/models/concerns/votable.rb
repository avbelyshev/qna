module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def set_like!(user)
    votes.create!(user: user, value: 1) if can_vote?(user)
  end

  def set_dislike!(user)
    votes.create!(user: user, value: -1) if can_vote?(user)
  end

  def cancel_vote!(user)
    votes.where(user: user).delete_all if votes.exists?(user: user)
  end

  def rating
    votes.sum(:value)
  end

  private

  def can_vote?(user)
    !user.author_of?(self) && !votes.exists?(user: user)
  end
end
