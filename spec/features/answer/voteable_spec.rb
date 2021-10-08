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
        click_on(class: 'answer-upvote')

        expect(find('.vote-counter')).to have_content '0'
        expect(page).to have_content 'You need to login first!'
      end
    end
  end

  describe 'Authenticated user can vote' do
    background do
      login user
      visit question_path(question)
    end

    scenario 'upvote then downvote unfamiliar answer' do
      within(".answer-#{answer.id}") do
        click_on(class: 'answer-upvote')

        expect(find('.vote-counter')).to have_content '1'

        click_on(class: 'answer-downvote')

        expect(find('.vote-counter')).to have_content '-1'
      end
    end

    scenario 'downvote unfamiliar answer' do
      within(".answer-#{answer.id}") do
        click_on(class: 'answer-downvote')

        expect(find('.vote-counter')).to have_content '-1'
      end
    end

    scenario 'upvote own answer' do
      within(".answer-#{answer.id}") do
        click_on(class: 'answer-upvote')

        expect(find('.vote-counter')).to have_content '0'
      end
    end
  end
end
