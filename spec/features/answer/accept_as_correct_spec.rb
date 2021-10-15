feature 'User can mark answer as correct', "
  In order to show the correct answer
  As author of question
  I'd like to be able to mark the answer" do
  let!(:user) { create(:user) }
  let!(:question) { create(:question_with_answers, author: user) }
  let!(:answer) { create(:answer, question: question) }
  let!(:own_answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      login user
      visit question_path(question)
    end

    it 'can mark any answer' do
      within("#answer-#{answer.id}") do
        click_on(class: 'answer-mark')

        expect(page).to have_css('.correct')
      end

      expect(page).to have_css('.correct', count: 1)
    end

    it 'cannt mark own answer' do
      within("#answer-#{own_answer.id}") do
        click_on(class: 'answer-mark')

        expect(page).not_to have_css('.correct')
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      question.answers.first.update(correct: true)
      visit question_path(question)
    end

    it 'can`t mark answers' do
      within("#answer-#{answer.id}") do
        expect(page).not_to have_css('.answer-mark')
      end
    end

    it 'can see what answer has been marked' do
      expect(page).to have_css('.correct', count: 1)
    end
  end
end
