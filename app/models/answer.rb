class Answer < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, :question, presence: true
  validate :correct_answers

  def correct_answers
    errors.add(:correct) if correct && question.correct_answer.present? && question.correct_answer != self
  end

  def mark_as(correct)
    ActiveRecord::Base.transaction do
      question.answers.each { |answer| answer.update(correct: false) }
      update!(correct: correct)
    end
  end
end
