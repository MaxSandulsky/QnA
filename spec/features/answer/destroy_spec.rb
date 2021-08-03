feature 'User can delete own answers', %q{
  I'd like to be able to delete owned answer
  As an authenticated user
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background { login user }

  scenario 'tries to delete own answer' do
    create(:answer, question: question, author: user, body: 'Answer to remove')
    visit question_path(question)
    click_on 'Удалить ответ'

    expect(page).to have_content('Ответ был удален')
    expect(page).not_to have_content('Answer to remove')
  end

  scenario 'tries to delete unfamiliar question' do
    create(:answer, question: question, body: 'Answer should remain')
    visit question_path(question)
    click_on 'Удалить ответ'

    expect(page).to have_content('Вопрос вам не принадлежит')
    expect(page).to have_content('Answer should remain')
  end
end
