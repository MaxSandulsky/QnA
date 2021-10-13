RSpec.describe User, type: :model do
  it { is_expected.to respond_to(:questions) }
  it { is_expected.to respond_to(:answers) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:dif_question) { create(:question) }

    it 'returns true if user is an author of' do
      expect(user).to be_author_of(question)
    end

    it 'returns false if user isn an author of' do
      expect(user).not_to be_author_of(dif_question)
    end
  end

  describe '#rewards' do
    let(:user) { create(:user) }
    let(:first_question) { create(:question_with_rewards) }
    let(:second_question) { create(:question_with_rewards) }
    let!(:first_answer) { create(:answer, question: first_question, correct: true, author: user) }
    let!(:second_answer) { create(:answer, question: second_question, correct: true, author: user) }

    it 'has rewards' do
      expect(user.rewards.count).to eq 2
    end
  end

  describe '#vote_for' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let!(:vote) { create(:vote, user: user, voteable: answer) }

    it 'could have vote' do
      expect(user.vote_for(answer)).to eq(vote)
    end
  end
end
