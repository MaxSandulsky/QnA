describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }

    it { is_expected.not_to be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user)  }
    let(:other) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:others_question) { create(:question, author: other) }

    it { is_expected.not_to be_able_to :manage, :all }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }
    it { is_expected.to be_able_to :read, Reward }

    it { is_expected.to be_able_to :create, Question }
    it { is_expected.to be_able_to :create, Answer }
    it { is_expected.to be_able_to :create, Comment }
    it { is_expected.to be_able_to :create, Reward }

    it { is_expected.to be_able_to :update, create(:question, author: user) }
    it { is_expected.to be_able_to :update, create(:answer, author: user) }
    it { is_expected.not_to be_able_to :update, create(:question, author: other)}
    it { is_expected.not_to be_able_to :update, create(:answer, author: other)}

    it { is_expected.to be_able_to :destroy, create(:question, author: user) }
    it { is_expected.to be_able_to :destroy, create(:answer, author: user) }
    it { is_expected.not_to be_able_to :destroy, create(:question, author: other)}
    it { is_expected.not_to be_able_to :destroy, create(:answer, author: other)}

    it { is_expected.to be_able_to :upvote, create(:question, author: other) }
    it { is_expected.to be_able_to :downvote, create(:question, author: other) }
    it { is_expected.to be_able_to :upvote, create(:answer, author: other) }
    it { is_expected.to be_able_to :downvote, create(:answer, author: other) }
    it { is_expected.not_to be_able_to :upvote, create(:question, author: user) }
    it { is_expected.not_to be_able_to :downvote, create(:question, author: user) }
    it { is_expected.not_to be_able_to :upvote, create(:answer, author: user) }
    it { is_expected.not_to be_able_to :downvote, create(:answer, author: user) }

    it { is_expected.to be_able_to :remove_attachment, create(:answer, author: user) }
    it { is_expected.to be_able_to :remove_attachment, create(:question, author: user) }
    it { is_expected.not_to be_able_to :remove_attachment, create(:answer, author: other) }
    it { is_expected.not_to be_able_to :remove_attachment, create(:question, author: other) }

    it { is_expected.to be_able_to :mark, create(:answer, question: question) }
    it { is_expected.not_to be_able_to :mark, create(:answer, question: others_question) }

    it { is_expected.to be_able_to :new_comment, create(:answer) }
    it { is_expected.to be_able_to :new_comment, create(:question) }
    it { is_expected.to be_able_to :create_comment, create(:answer) }
    it { is_expected.to be_able_to :create_comment, create(:question) }

  end
end
