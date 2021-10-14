feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  describe 'User' do
    let(:user) { create(:user) }

    context 'Authenticated' do
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

      it 'tries to create question with file' do
        fill_in 'Заголовок', with: 'Test question title'
        fill_in 'Описание', with: 'Body for test question'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Сохранить'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      it 'tries to create question with errors' do
        click_on 'Сохранить'

        expect(page).to have_content 'Заголовок вопроса не может быть пустым'
      end
    end

    context 'multiple sessions', js: true do
      scenario 'answer appears on another users page' do
        Capybara.using_session('user') do
          login user
          visit new_question_path
        end

        Capybara.using_session('guest') do
          visit questions_path
        end

        Capybara.using_session('user') do
          fill_in 'Заголовок', with: 'Test question title'
          fill_in 'Описание', with: 'Body for test question'
          click_on 'Сохранить'

          expect(page).to have_content 'Test question title'
          expect(page).to have_content 'Ваш вопрос успешно создан!'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test question title'
        end
      end
    end
  end

  it 'Unauthenticated user tries to create question' do
    visit questions_path

    expect(page).not_to have_selector(:link_or_button, 'Ask question')
  end
end
