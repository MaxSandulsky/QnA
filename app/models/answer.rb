class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, :question, presence: true
  validate :correct_answers

  def correct_answers
    errors.add(:correct) if !errors.present? && question.correct_answer.present? && question.correct_answer != self
  end

  def mark_as(correct)
    ActiveRecord::Base.transaction do
      question.answers.each { |answer| answer.update(correct: false) }
      update!(correct: correct)
    end
  end
end
