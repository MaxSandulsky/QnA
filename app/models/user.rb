class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers, inverse_of: 'author', foreign_key: 'author_id'
  has_many :questions, inverse_of: 'author', foreign_key: 'author_id'
end
