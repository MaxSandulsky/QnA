class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true

  validate :proper_url

  def proper_url
    errors.add(:url) if !URI.regexp.match? url
  end

  def gist?
    true if /gist.github.com/.match?(url) || /api.github.com\/gists/.match?(url)
  end
end
