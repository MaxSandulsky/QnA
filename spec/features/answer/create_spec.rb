feature 'User can create answer', "
  In order to give an answer to question
  As an authenticated user
  I'd like to be able to write the answer to question" do
  let(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    let(:user) { create(:user) }

    background do
      login user

      visit question_path(question)
      click_on 'I have answer'
    end

    it 'can see appiared form' do
      within '.new_answer' do
        expect(page).to have_selector 'textarea'
      end
    end

    it 'tries to create answer' do
      fill_in 'Новый ответ', with: 'Answer body'
      click_on 'Сохранить'

      within '.answers' do
        expect(page).to have_content 'Answer body'
      end

      expect(page).to have_content 'Ответ успешно сохранён'

      within '.new_answer' do
        expect(page).to_not have_selector 'textarea'
      end
    end

    it 'tries to create answer with file' do
      fill_in 'Новый ответ', with: 'Answer body'

      attach_file 'Прикрепить файлы', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Сохранить'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    it 'tries to save invalid answer' do
      click_on 'Сохранить'

      within '.new_answer' do
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content 'Тело ответа не может быть пустым!'
    end
  end

  it 'Unregistered user tries to save answer', js: true do
    visit question_path(question)
    click_on 'I have answer'
    fill_in 'Новый ответ', with: 'Answer body'
    click_on 'Сохранить'

    expect(page).to have_content 'You need to login first!'
    expect(page).to_not have_content 'Answer body'
  end
end
