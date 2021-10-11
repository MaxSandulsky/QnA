module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :voteable

    def votes_sum
      votes.where(promote: true).count - votes.where(promote: false).count
    end
  end
end
