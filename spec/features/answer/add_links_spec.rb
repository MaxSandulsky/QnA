feature 'User can add link to answer', "
  In order to provide additional info to answer
  As an author of answer
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/MaxSandulsky/659290bad6df910b28d514bed4cfd22a' }

  background do
    login user

    visit question_path(question)
    click_on 'I have answer'
  end

  scenario 'User can add a link when giving an answer', js: true do
    fill_in 'Новый ответ', with: 'Answer body'

    fill_in 'Текст ссылки', with: 'Моя ссылка'
    fill_in 'Адрес ссылки', with: gist_url
    click_on 'Сохранить'

    within '.answers' do
      expect(page).to have_link 'Моя ссылка', href: gist_url
    end
  end

end
