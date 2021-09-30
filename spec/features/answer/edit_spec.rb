feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:own_answer) { create(:answer, question: question, author: user) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user can`t edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Изменить'
  end

  describe 'Authenticated user', js: true do
    background do
      login user
      visit question_path(question)
    end

    scenario 'edits his answer with valid attributes' do
      within(".answer-#{own_answer.id}") do
        click_on 'Изменить'
        fill_in 'Изменить ответ', with: 'edited answer'
        click_on 'Сохранить'

        expect(page).to_not have_content own_answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end

      expect(page).to have_content 'Ответ сохранён'
    end

    scenario 'add files while editing answer' do
      click_on 'Изменить'
      attach_file 'Прикрепить файлы', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Сохранить'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'edits his answer with errors' do
      within(".answer-#{own_answer.id}") do
        click_on 'Изменить'
        fill_in 'Изменить ответ', with: ''
        click_on 'Сохранить'

        expect(page).to have_content own_answer.body
        expect(page).to have_content 'Тело ответа не может быть пустым!'
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'edits unfamiliar answer' do
      within(".answer-#{answer.id}") do
        expect(page).to_not have_link 'Изменить'
      end
    end
  end
end
