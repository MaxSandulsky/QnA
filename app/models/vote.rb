class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :user, :voteable, presence: true

  validate :uniqueness

  def uniqueness
    errors.add(:id) if Vote.where(user: user, voteable: voteable, promote: promote).count >= 1
  end

  def purge_votes
    Vote.where(user: user, voteable: voteable).reject { |vote| vote == self }.each(&:destroy)
  end
end
