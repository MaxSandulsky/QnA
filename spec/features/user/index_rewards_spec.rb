feature 'User can see his rewards', "
  In order to see correct answers to questions
  I'd like to be able to see my rewards
" do
  given(:user) { create(:user) }
  given(:first_question) { create(:question_with_rewards) }
  given(:second_question) { create(:question_with_rewards) }
  given(:third_question) { create(:question_with_rewards) }
  let!(:first_answer) { create(:answer, question: first_question, correct: true, author: user) }
  let!(:second_answer) { create(:answer, question: second_question, correct: true, author: user) }
  let!(:hird_answer) { create(:answer, question: third_question, correct: true) }

  scenario 'User can see only his rewards' do
    login user
    visit rewards_path

    expect(page).to have_content('MyReward', count: 2)
    expect(page).to have_css('img', count: 2)
  end
end
