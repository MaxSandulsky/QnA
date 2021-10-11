feature 'User can vote for question', "
  In order to promote liked question
  As authenticated user
  I'd like to be able to vote for question
" do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:own_question) { create(:question, author: user) }

  describe 'Unauthenticated users cant vote' do
    scenario 'upvote unfamiliar question' do
      visit question_path(question)

      within(".question-#{question.id}") do
        click_on(class: 'question-vote', match: :first)
      end

      expect(page).to have_content 'You need to login first!'
    end
  end

  describe 'Authenticated user can vote' do
    background do
      login user
    end

    scenario 'upvote then unvote unfamiliar question', js: true do
      visit question_path(question)

      within(".question-#{question.id}") do
        click_on(class: 'question-vote', match: :first)

        expect(find('.vote-sum')).to have_content '1'

        click_on(class: 'question-vote', match: :first)

        expect(find('.vote-sum')).to have_content '0'
      end
    end

    scenario 'upvote own question' do
      visit question_path(own_question)

      within(".question-#{own_question.id}") do
        expect(page).not_to have_css 'question-vote'
      end
    end
  end
end
