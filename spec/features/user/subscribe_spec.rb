feature 'User can subscribe to question', "
  In order to see new answers to my question
  I'd like to be subscribed
" do
  describe 'User', js: true do
    let(:user) { create(:user) }

    before { login user }

    describe 'and his question' do
      background {
        visit questions_path
        click_on 'Ask question'
        fill_in 'Заголовок', with: 'Test question title'
        fill_in 'Описание', with: 'Body for test question'
        click_on 'Сохранить'
      }

      it 'subscribed by default' do
        sleep 1
        expect(user.subs.count).to eq 1
      end

      it 'can unsubscribe' do
        visit questions_path
        click_on 'Test question title'
        click_on 'Отписаться'

        sleep 1
        expect(user.subs.count).to eq 0
      end
    end

    describe 'with another question' do
      let(:question) { create(:question) }

      it 'can subscribe' do
        visit question_path(question)

        click_on 'Подписаться'

        sleep 1
        expect(question.subscribed?(user)).to be_truthy
      end

      it 'can unsubscribe' do
        question.subscribers << user
        visit question_path(question)

        click_on 'Отписаться'

        sleep 1
        expect(question.subscribed?(user)).to be_falsey
      end
    end
  end
end
