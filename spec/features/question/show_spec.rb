feature 'User can see question and related answers', %q{
  In order to see question
  As any user
  I'd like to be able to see the question description and answers
} do

    given(:user) { create(:user) }
    given(:question) { create(:question_with_answers, answers_count: 3) }
    given(:show_question) do
      visit questions_path(question)
      click_link('Some question with answers')
    end

    scenario 'Authenticated user tries to see question and answers', js: true do
      login user
      show_question
      expect(page.all('.answer').count).to be > 0
    end

    scenario 'Unauthenticated user tries to see question and answers', js: true do
      show_question
      expect(page.all('.answer').count).to be > 0
    end
end
