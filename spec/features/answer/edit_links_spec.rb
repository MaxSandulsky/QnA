feature 'User can edit links of the answer', "
  In order to correct wrong link
  As an author of answer
  I'd like to be able to edit links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'User can remove existing link', js: true do
    login user
    visit question_path(question)

    click_on 'Изменить'
    fill_in 'Текст ссылки', with: 'Edited link'
    fill_in 'Адрес ссылки', with: root_url
    click_on 'Сохранить'

    expect(page).to have_link 'Edited link', href: root_url
  end
end
