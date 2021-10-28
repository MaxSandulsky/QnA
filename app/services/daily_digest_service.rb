class DailyDigestService
  def send_digest
    @yesterday_questions = Question.last24hours

    User.find_each(batch_size: 100) do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
