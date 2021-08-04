describe 'User can delete own questions', "
  I'd like to be able to delete owned question
  As an authenticated user
" do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user, title: 'Question to remove') }
  let(:unfamiliar_question) { create(:question, title: 'Question should remain') }

  before { login user }

  it 'tries to delete own question' do
    visit question_path(question)
    click_on 'Удалить вопрос'

    expect(page).to have_content('Вопрос был удален')
    expect(page).not_to have_content('Question to remove')
  end

  it 'tries to delete unfamiliar question' do
    visit question_path(unfamiliar_question)
    click_on 'Удалить вопрос'

    expect(page).to have_content('Вопрос вам не принадлежит')
    expect(page).to have_content('Question should remain')
  end
end
