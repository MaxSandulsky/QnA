class DailyDigestMailer < ApplicationMailer
  def digest(user)
    mail to: user.email, subject: 'Daily digest from QnA!'
  end
end
