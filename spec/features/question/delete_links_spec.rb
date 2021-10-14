feature 'User can delete link from question', "
  In order to remove unwanted link
  As an author of question
  I'd like to be able to remove links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:link) { create(:link, linkable: question) }

  scenario 'User can remove existing link', js: true do
    login user
    visit question_path(question)

    expect(page).to have_link link.name, href: link.url

    click_on 'Изменить вопрос'
    click_on 'Удалить ссылку'
    click_on 'Сохранить'

    expect(page).to_not have_link link.name, href: link.url
  end
end
