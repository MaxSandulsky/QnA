class SubscriptionService
  def send_notification(question)
    @subscribers = question.subscribers

    @subscribers.find_each(batch_size: 100) do |user|
      SubscriptionMailer.notification(user, question).deliver_later
    end
  end
end
