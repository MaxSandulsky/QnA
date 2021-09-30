feature 'User can delete own questions', "
  I'd like to be able to delete owned question
  As an authenticated user
" do
  let(:user) { create(:user) }
  let(:own_question) { create(:question, author: user, title: 'Question to remove') }
  let(:question) { create(:question, title: 'Question should remain') }

  describe 'Authenticated user' do
    background { login user }

    it 'tries to delete own question' do
      visit question_path(own_question)

      expect(page).to have_content('Question to remove')

      click_link('Удалить вопрос', href: question_path(own_question))

      expect(page).to have_content('Вопрос был удален')
      expect(page).not_to have_content('Question to remove')
    end

    it 'tries to delete unfamiliar question' do
      visit question_path(question)

      expect(page).not_to have_link('Удалить вопрос', href: question_path(question))
      expect(page).to have_content('Question should remain')
    end
  end

  describe 'Unauthenticated user' do
    it 'tries to delete question' do
      visit question_path(question)

      expect(page).not_to have_link('Удалить вопрос', href: question_path(question))
      expect(page).to have_content('Question should remain')
    end
  end
end
