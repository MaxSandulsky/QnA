class Question < ApplicationRecord
  include Voteable
  include Commentable

  belongs_to :author, class_name: 'User'

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :reward, dependent: :destroy

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :body, :title, presence: true

  after_create :calculate_reputation

  def sort_answers
    answers.order(correct: :desc)
  end

  def correct_answer
    answers.find_by(correct: true)
  end

  def self.load_with_attachments
    all.with_attached_files.includes(:links, :comments, :answers)
  end

  private

  def calculate_reputation
    ReputationService.calculate(self)
  end
end
