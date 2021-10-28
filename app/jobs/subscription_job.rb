class SubscriptionJob < ApplicationJob
  queue_as :default

  def perform(question)
    SubscriptionService.new.send_notification(question)
  end
end
