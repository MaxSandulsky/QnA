feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  describe 'Authenticated user' do
    let(:user) { create(:user) }

    background do
      login user

      visit questions_path
      click_on 'Ask question'
    end

    it 'tries to create question' do
      fill_in 'Заголовок', with: 'Test question title'
      fill_in 'Описание', with: 'Body for test question'
      click_on 'Сохранить'

      expect(page).to have_content 'Test question title'
      expect(page).to have_content 'Ваш вопрос успешно создан!'
    end

    it 'tries to create question with errors' do
      click_on 'Сохранить'

      expect(page).to have_content 'Заголовок вопроса не может быть пустым'
    end
  end

  it 'Unauthenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to login first!'
  end
end
