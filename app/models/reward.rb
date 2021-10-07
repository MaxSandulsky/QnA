class Reward < ApplicationRecord
  belongs_to :question

  has_one_attached :picture, dependent: :destroy

  validates :name, :picture, presence: true

  validate :picture_format

  def picture_format
    errors.add(:picture) unless /.(jpg|png)$/.match? picture.filename.to_s
  end
end
