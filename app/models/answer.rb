class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, :question, presence: true
  validate :correct_answers

  def correct?
    correct
  end

  def correct_answers
    errors.add(:correct) if question && question.correct_answer.present? && correct? && question.correct_answer.id != id
  end

  def mark_as(correct)
    ActiveRecord::Base.transaction do
      question.answers.each { |answer| answer.update(correct: false) }
      update!(correct: correct)
    end
  end
end
