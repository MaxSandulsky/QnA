feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  scenario 'Unauthenticated user can`t edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Изменить'
  end

  describe 'Authenticated user', js: true do
    background do
      question.files.attach(io: File.open("#{Rails.root}/config/storage.yml"), filename: 'storage.yml')

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

    scenario 'add files while editing question' do
      click_on 'Изменить вопрос'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      sleep 3
      click_on 'Сохранить'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'delete files while editing question' do
      click_on 'Изменить вопрос'
      click_on(class: "file-delete-#{question.files.first.id}")
      sleep 3
      click_on 'Сохранить'

      expect(page).to_not have_link 'storage.yml'
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
      expect(find('#question_title')).to be_visible
      expect(find('#question_body')).to be_visible
    end
  end
end
