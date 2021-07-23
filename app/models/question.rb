class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :body, presence: true
  validates :title, presence: true
end
