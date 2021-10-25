class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers, inverse_of: 'author', foreign_key: 'author_id'
  has_many :questions, inverse_of: 'author', foreign_key: 'author_id'
  has_many :comments, inverse_of: 'author', foreign_key: 'author_id'
  has_many :votes, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subs, source: :question, through: :subscriptions

  scope :others, ->(user) { where.not(id: user.id) }

  def rewards
    answers.select(&:correct?).map(&:question).map(&:reward)
  end

  def vote_for(voteable)
    votes.find_by(voteable: voteable)
  end

  def author_of?(res)
    res.author == self
  end
end
