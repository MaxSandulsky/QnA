feature 'User can mark answer as correct', "
  In order to show the correct answer
  As an authenticated user
  I'd like to be able to mark the answer" do
  let!(:question) { create(:question_with_answers) }
  let(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      login user
      question.answers.first.update(correct: true)
      visit question_path(question)

    end

    it 'can mark any answer' do
      find(:xpath, "/HTML/BODY[1]/DIV[2]/DIV[2]/DIV[1]/DIV[2]/A[1]").click
      expect(page).to have_content('Ответ сохранён')
    end

    it 'can be only one correct answer' do
      expect(page).to have_css(".correct", count: 1)
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      question.answers.first.update(correct: true)
      visit question_path(question)
    end

    it 'can`t mark answers' do
      find(:xpath, "/HTML/BODY[1]/DIV[2]/DIV[2]/DIV[1]/DIV[2]/A[1]").click
      expect(page).to have_content 'You need to login first!'
    end

    it 'can see what answer has been marked' do
      expect(page).to have_css(".correct", count: 1)
    end
  end
end