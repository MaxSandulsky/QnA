feature 'User can edit links of the question', "
  In order to correct wrong link
  As an author of question
  I'd like to be able to edit links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

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
