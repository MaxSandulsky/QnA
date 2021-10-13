feature 'User can comment question', "
  In order to provide additional information
  As authenticated user
  I'd like to be able to comment question
" do
  describe 'Users' do
    let(:user) { create(:user) }
    let(:owner) { create(:user) }
    let(:question) { create(:question, author: owner) }

    context 'Authenticated', js: true do
      let(:comment) do
        click_on 'Добавить комментарий'

        fill_in 'Ваш комментарий', with: 'New comment'

        click_on 'Сохранить комментарий'
      end

      context 'Owner' do
        it 'can comment questions' do
          login owner
          visit question_path(question)

          within("#question-#{question.id}") do
            comment

            expect(page).to have_content 'New comment'
          end
        end
      end

      context 'User' do
        it 'can comment questions' do
          login user
          visit question_path(question)

          within("#question-#{question.id}") do
            comment

            expect(page).to have_content 'New comment'
          end
        end
      end

      context 'multiple sessions' do
        scenario 'comment appears on another users page' do
          Capybara.using_session('user') do
            login user
            visit question_path(question)
          end

          Capybara.using_session('owner') do
            login owner
            visit question_path(question)
          end

          Capybara.using_session('user') do
            within("#question-#{question.id}") do
              comment

              expect(page).to have_content 'New comment'
            end
          end

          Capybara.using_session('owner') do
            within("#question-#{question.id}") do
              expect(page).to have_content 'New comment'
            end
          end
        end
      end
    end
  end
end
