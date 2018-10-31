class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, optional: true, touch: true

  validates :value, presence: true, inclusion: [1, -1]
end
