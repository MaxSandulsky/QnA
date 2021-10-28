RSpec.describe SubscriptionJob, type: :job do
  let(:users_list) { create_list(:user, 3) }
  let(:question) { create(:question) }
  let(:service) { double('SubscriptionService') }

  before do
    allow(SubscriptionService).to receive(:new).and_return(service)
    question.subscribers << users_list
  end

  it "calls SubscriptionService#send_notification" do
    expect(service).to receive(:send_notification).with(question)
    SubscriptionJob.perform_now(question)
  end
end
