feature 'User can add link to answer', "
  In order to provide additional info to answer
  As an author of answer
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:gist_urls) { ['https://gist.github.com/MaxSandulsky/659290bad6df910b28d514bed4cfd22a',
                       'https://gist.github.com/MaxSandulsky/a85438e937e4da64645a0b560d8a4bd0'] }
  given(:urls_names) { ['Первый гист', 'Второй гист'] }

  describe 'User when giving an answer' do
    background do
      login user

      visit question_path(question)
      click_on 'I have answer'

      fill_in 'Новый ответ', with: 'Answer body'
      click_on 'Добавить ссылку'
    end

    scenario 'can add proper link ', js: true do
      click_on 'Добавить ссылку'

      fields = page.all(class: 'nested-fields')
      fields.each_with_index do |field, i|
        within(field) do
          fill_in 'Текст ссылки', with: urls_names[i]
          fill_in 'Адрес ссылки', with: gist_urls[i]
        end
      end

      click_on 'Сохранить'

      within '.answers' do
        expect(page).to have_link urls_names[0]
        expect(page).to have_link urls_names[1]
      end
    end

    scenario 'cannt add invalid link', js: true do
      fill_in 'Текст ссылки', with: urls_names[0]
      fill_in 'Адрес ссылки', with: 'gist_urls[i]'

      click_on 'Сохранить'

      expect(page).to_not have_content urls_names[0]
      expect(page).to have_content 'Неправильный формат ссылки'
    end
  end

  describe 'User when editing answer' do
    background do
      login user
      visit question_path(question)
      click_on 'Изменить'
      click_on 'Добавить ссылку'
    end

    scenario 'can add proper link', js: true do
      click_on 'Добавить ссылку'

      fields = page.all(class: 'nested-fields')
      fields.each_with_index do |field, i|
        within(field) do
          fill_in 'Текст ссылки', with: urls_names[i]
          fill_in 'Адрес ссылки', with: gist_urls[i]
        end
      end
      click_on 'Сохранить'

      expect(page).to have_link urls_names[0]
      expect(page).to have_link urls_names[1]
    end

    scenario 'cannt add invalid link', js: true do
      fill_in 'Текст ссылки', with: urls_names[0]
      fill_in 'Адрес ссылки', with: 'gist_urls[i]'

      click_on 'Сохранить'

      expect(page).to_not have_content urls_names[0]
      expect(page).to have_content 'Неправильный формат ссылки'
    end
  end

  describe 'links to gists shows contents', js: true do
    scenario 'User types gist url' do
      login user

      visit question_path(question)
      click_on 'I have answer'
      click_on 'Добавить ссылку'

      fill_in 'Новый ответ', with: 'Answer body'
      fill_in 'Текст ссылки', with: urls_names[0]
      fill_in 'Адрес ссылки', with: gist_urls[0]

      click_on 'Сохранить'

      expect(page).to have_content 'In Ruby, everything is ...'
    end
  end
end
