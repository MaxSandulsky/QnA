require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to respond_to(:questions) }
  it { is_expected.to respond_to(:answers) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:dif_question) { create(:question) }

    it 'should return true if user is an author of' do
      expect(user).to be_author_of(question)
    end

    it 'should return false if user isn an author of' do
      expect(user).not_to be_author_of(dif_question)
    end
  end
end
