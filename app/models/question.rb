class Question < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_many :answers, dependent: :destroy

  validates :body, :title, presence: true

  def sort_answers
    answers.order( correct: :desc )
  end

  def correct_answer
    answers.find_by(correct: true)
  end
end
