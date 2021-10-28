RSpec.describe SubscriptionService do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question) }

  before { question.subscribers << users }

  it 'sends notification to subscribed users' do
    question.subscribers.each { |user| expect(SubscriptionMailer).to receive(:notification).with(user, question).and_call_original }
    subject.send_notification(question)
  end
end
