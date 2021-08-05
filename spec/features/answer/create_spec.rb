feature 'User can create answer', "
  In order to give an answer to question
  As an authenticated user
  I'd like to be able to write the answer to question
" do
  let(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    let(:user) { create(:user) }

    background do
      login user

      visit question_path(question)
      page.execute_script("document.querySelector('.answer-button').click()")
    end

    it 'can see appiared form' do
      expect(page.find('.form-answer')['class']).not_to include('hide')
    end

    it 'save valid answer' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Save'

      expect(page).to have_content 'Answer body'
      expect(page).to have_content 'Ваш ответ успешно сохранен!'
    end

    it 'tries to save invalid answer' do
      click_on 'Save'

      expect(page.find('.form-answer')['class']).not_to include('hide')
      expect(page).to have_content 'Тело ответа не может быть пустым!'
    end
  end

  it 'Unregistered user tries to save answer', js: true do
    visit question_path(question)
    page.execute_script("document.querySelector('.answer-button').click()")
    click_on 'Save'

    expect(page).to have_content 'Forgot your password?'
  end
end
