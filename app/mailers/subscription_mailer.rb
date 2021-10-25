class SubscriptionMailer < ApplicationMailer
  def notification(user, question)
    mail(to: user.email,
         subject: 'New answer to question you subscribed!') do |format|
      format.html { render 'notification', locals: { question: question } }
      format.text { render plain: 'notification', locals: { question: question } }
    end
  end
end
