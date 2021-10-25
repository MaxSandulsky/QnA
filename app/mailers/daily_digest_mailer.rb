class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi"

    mail to: user.email, subject: 'Daily digest from QnA!'
  end
end
