class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validate :proper_url

  after_validation :transform_if_gist

  def proper_url
    errors.add(:url) if !URI.regexp.match? url
  end

  def gist?
    true if /gist.github.com/.match?(url) || /api.github.com\/gists/.match?(url)
  end

  def transform_if_gist
    if gist?
      self.url = self.url.gsub(/\A.+\/{2}.+\/.+\//, 'https://api.github.com/gists/')
    end
  end
end
