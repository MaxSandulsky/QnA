feature 'User can delete link from answer', "
  In order to remove unwanted link
  As an author of answer
  I'd like to be able to remove links
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, author: user) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'User can remove existing link', js: true do
    login user
    visit question_path(question)

    within("#answer-#{answer.id}") do
      expect(page).to have_link link.name, href: link.url

      click_on 'Изменить'
      click_on 'Удалить ссылку'
      click_on 'Сохранить'

      expect(page).to_not have_link link.name, href: link.url
    end
  end
end
