feature 'User can see question and related answers', "
  In order to see question
  As any user
  I'd like to be able to see the question description and answers
" do
  let(:user) { create(:user) }
  let(:question) { create(:question_with_answers, answers_count: 2) }

  it 'Authenticated user tries to see question and answers' do
    login user
    visit question_path(question)

    expect(page).to have_content('Some question with answers')
    expect(page).to have_content('Some description')
    expect(page).to have_content('Some answer', minimum: 2)
  end

  it 'Unauthenticated user tries to see question and answers' do
    visit question_path(question)

    expect(page).to have_content('Some question with answers')
    expect(page).to have_content('Some description')
    expect(page).to have_content('Some answer', minimum: 2)
  end
end
