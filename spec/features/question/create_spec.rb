feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  describe 'Authenticated user' do
    given(:user) {create(:user) }

    background do
      login user

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'tries to create question' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body', with: 'Body for test question'
      click_on 'Ask'

      expect(page).to have_content 'Test question title'
      expect(page).to have_content 'Ваш вопрос успешно создан!'
    end

    scenario 'tries to create question with errors' do
      click_on 'Ask'

      expect(page).to have_content 'Заголовок вопроса не может быть пустым'
    end
  end

  scenario 'Unauthenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'Forgot your password?'
  end
end
