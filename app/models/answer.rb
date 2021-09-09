class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, :question, presence: true
  validate :correct_answers

    def correct?
      correct
    end

  def correct_answers
    if question && question.correct_answer.present? && self.correct? && question.correct_answer.id != self.id
        errors.add(:correct)
    end
  end
end
