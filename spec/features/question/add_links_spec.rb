feature 'User can add link to question', "
  In order to provide additional info to question
  As an author of question
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_urls) { ['https://gist.github.com/MaxSandulsky/659290bad6df910b28d514bed4cfd22a',
                       'https://gist.github.com/MaxSandulsky/a85438e937e4da64645a0b560d8a4bd0'] }
  given(:urls_names) { ['Первый гист', 'Второй гист'] }

  scenario 'User can add a link when asking a question', js: true do
    login user
    visit new_question_path

    fill_in 'Заголовок', with: 'Test question title'
    fill_in 'Описание', with: 'Body for test question'
    click_on 'Добавить ссылку'

    fields = page.all(class: 'nested-fields')
    fields.each_with_index do |field, i|
      within(field) do
        fill_in 'Текст ссылки', with: urls_names[i]
        fill_in 'Адрес ссылки', with: gist_urls[i]
      end
    end

    click_on 'Сохранить'

    expect(page).to have_link 'Первый гист', href: gist_urls[0]
    expect(page).to have_link 'Второй гист', href: gist_urls[1]
  end

end
