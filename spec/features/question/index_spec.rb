describe 'User can see all questions', "
  In order to see questions from a community
  As any user
  I'd like to be able to see the questions
" do
  let(:user) { create(:user) }
  let(:questions) { create_list(:question_with_answers, 2) }

  it 'Authenticated user tries to see questions' do
    login user
    visit questions_path(questions)

    expect(page).to have_content('Some question', minimum: 2)
  end

  it 'Unauthenticated user tries to see questions' do
    visit questions_path(questions)

    expect(page).to have_content('Some question', minimum: 2)
  end
end
