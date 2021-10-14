class RewardsController < ApplicationController
  load_and_authorize_resource

  def index
    @rewards = current_user.rewards.reject(&:nil?)
  end
end
