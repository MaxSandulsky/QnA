class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers, inverse_of: 'author', foreign_key: 'author_id'
  has_many :questions, inverse_of: 'author', foreign_key: 'author_id'

  def author_of?(subject)
    subject.author_id == id
  end

  def rewards
    answers.select(&:correct?).map(&:question).map(&:reward)
  end
end
