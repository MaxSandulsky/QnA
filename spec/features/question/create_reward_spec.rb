feature 'User can create reward', "
  In order to reward another user
  for correct answer
  I'd like to be adle to create reward
" do
  given(:user) { create(:user) }

  background do
    login user
    visit new_question_path

    fill_in 'Заголовок', with: 'Test question title'
    fill_in 'Описание', with: 'Body for test question'
  end

  scenario 'User can create reward while creating question', js: true do
    click_on 'Добавить награду'

    within '.reward-fields' do
      fill_in 'Название награды', with: 'Награда за правильный ответ'
      attach_file 'Изображение', "#{Rails.root}/spec/support/test_image.jpg"
    end

    click_on 'Сохранить'
    sleep 1
    expect(Question.last.reward.picture.filename.to_s).to eq 'test_image.jpg'
    expect(Question.last.reward.name).to eq 'Награда за правильный ответ'
  end
end
