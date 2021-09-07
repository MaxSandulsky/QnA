feature 'User can mark answer as correct', "
  In order to show the correct answer
  As an authenticated user
  I'd like to be able to mark the answer" do
  let!(:question) { create(:question_with_answers) }
  let(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      login user
      visit question_path(question)
    end

    it 'can mark any answer' do
      click_on heroicon "check"
      byebug
      expect(page).to have_css(".correct", count: 1)
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(question)
    end

    it 'can`t mark answers' do
      find(".answer-mark", match: :first).click
      expect(page).to have_content 'You need to login first!'
    end

    it 'can see what answer has been marked' do
      find(".answer-mark", match: :first).click
      expect(page).to have_css(".correct", count: 1)
    end
  end
end