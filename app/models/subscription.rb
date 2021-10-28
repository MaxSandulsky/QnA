class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validate :only_one

  def only_one
    errors.add(:exist) if Subscription.where(user: user, question: question ).present?
  end
end
