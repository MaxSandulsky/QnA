feature 'User can see all questions', %q{
  In order to see questions from a community
  As any user
  I'd like to be able to see the questions
} do

  given(:user) { create(:user) }
  given(:questions) { 2.times { create(:question_with_answers) } }

  scenario 'Authenticated user tries to see questions', js: true do


    login user

    visit questions_path(questions)

    expect(page.all('.question').count).to be > 0
  end

  scenario 'Unauthenticated user tries to see questions', js: true do
    visit questions_path(questions)

    expect(page.all('.question').count).to be > 0
  end
end
