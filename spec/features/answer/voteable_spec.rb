feature 'User can vote for answer', "
  In order to promote liked answer
  As authenticated user
  I'd like to be able to vote for answer
" do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:own_answer) { create(:answer, question: question, author: user) }

  describe 'Unauthenticated users cant vote' do
    scenario 'upvote unfamiliar answer' do
      visit question_path(question)

      within(".answer-#{answer.id}") do
        click_on(class: 'answer-vote', match: :first)
      end
      
      expect(page).to have_content 'You need to login first!'
    end
  end

  describe 'Authenticated user can vote' do
    background do
      login user
      visit question_path(question)
    end

    scenario 'upvote then unvote unfamiliar answer', js: true do
      within(".answer-#{answer.id}") do
        click_on(class: 'answer-vote', match: :first)

        expect(find('.vote-sum')).to have_content '1'

        click_on(class: 'answer-vote', match: :first)

        expect(find('.vote-sum')).to have_content '0'
      end
    end

    scenario 'upvote own answer' do
      within(".answer-#{answer.id}") do
        expect(page).not_to have_css 'answer-vote'
      end
    end
  end
end
