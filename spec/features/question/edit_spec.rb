feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user can`t edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Изменить'
  end

  describe 'Authenticated user', js: true do
    background do
      login user
      visit question_path(question)
    end

    scenario 'edits his question' do
      click_on 'Изменить вопрос'
      fill_in 'Описание', with: 'edited description'
      fill_in 'Заголовок', with: 'edited title'
      click_on 'Сохранить'

      expect(page).to_not have_content 'Some question'
      expect(page).to_not have_content 'Some description'
      expect(page).to have_content 'edited description'
      expect(page).to have_content 'edited title'
      expect(page).to have_content 'Вопрос успешно изменён'
    end

    scenario 'edits his question with errors' do
      click_on 'Изменить вопрос'
      fill_in 'Описание', with: ''
      fill_in 'Заголовок', with: ''
      click_on 'Сохранить'

      expect(page).to have_content 'Some question'
      expect(page).to have_content 'Some description'
      expect(page).to have_content 'Заголовок вопроса не может быть пустым'
      expect(page).to have_content 'Описание вопроса не может быть пустым'
      find('#question_title').should be_visible
      find('#question_body').should be_visible
    end
  end
end