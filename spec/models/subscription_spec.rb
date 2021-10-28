RSpec.describe Subscription, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:question) }

  describe 'validates that it`s the only one subscription' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'is valid if only one subscription presented' do
      subscription = question.subscriptions.build(user: user)

      expect(subscription.valid?).to be_truthy
    end

    it 'shouldn`t` be valid if subscription already exist' do
      question.subscribers << user
      subscription = question.subscriptions.build(user: user)

      expect(subscription.valid?).to be_falsey
    end
  end
end
