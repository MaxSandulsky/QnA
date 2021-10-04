feature 'User can add link to question', "
  In order to provide additional info to question
  As an author of question
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/MaxSandulsky/659290bad6df910b28d514bed4cfd22a' }

  scenario 'User can add a link when asking a question', js: true do
    login user
    visit new_question_path

    fill_in 'Заголовок', with: 'Test question title'
    fill_in 'Описание', with: 'Body for test question'

    fill_in 'Текст ссылки', with: 'Моя ссылка'
    fill_in 'Адрес ссылки', with: gist_url
    click_on 'Сохранить'

    expect(page).to have_link 'Моя ссылка', href: gist_url
  end

end
