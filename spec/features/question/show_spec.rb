describe 'User can see question and related answers', "
  In order to see question
  As any user
  I'd like to be able to see the question description and answers
" do
  let(:user) { create(:user) }
  let(:question) { create(:question_with_answers, answers_count: 2) }
  let(:show_question) do
    visit questions_path(question)
    click_link('Some question with answers')
  end

  let(:question_expectations) do
    expect(page).to have_content('Some question with answers')
    expect(page).to have_content('Some desctription')
    expect(page).to have_content('Some answer', minimum: 2)
  end

  it 'Authenticated user tries to see question and answers' do
    login user
    show_question

    question_expectations
  end

  it 'Unauthenticated user tries to see question and answers' do
    show_question

    question_expectations
  end
end
