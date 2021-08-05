feature 'User can delete own answers', "
  I'd like to be able to delete owned answer
  As an authenticated user
" do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:own_answer) { create(:answer, question: question, author: user, body: 'Answer to remove') }
  let!(:answer) { create(:answer, question: question, body: 'Answer should remain') }

  describe 'Authenticated user' do
    background { login user }

    it 'tries to delete own answer' do
      visit question_path(question)

      expect(page).to have_content('Answer to remove')

      click_link('Удалить ответ', href: answer_path(own_answer))

      expect(page).to have_content('Ответ был удален')
      expect(page).not_to have_content('Answer to remove')
    end

    it 'tries to delete unfamiliar answer' do
      visit question_path(question)
      click_link('Удалить ответ', href: answer_path(answer))

      expect(page).to have_content('Вопрос вам не принадлежит')
      expect(page).to have_content('Answer should remain')
    end
  end

  describe 'Unauthenticated user' do
    it 'tries to delete answer' do
      visit question_path(question)

      expect(page).to have_content('Answer to remove')

      click_link('Удалить ответ', href: answer_path(answer))

      expect(page).to have_content 'Forgot your password?'
    end
  end
end
