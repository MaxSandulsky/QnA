feature 'User can sign out', "
  In order to exit
  As authenticated user
  I'd like to be able to sign out
 " do
   let(:user) { create(:user) }

   it 'Authenticated user tries to sign out' do
     login user

     click_link('Выйти')

     expect(page).to have_content('Вы вышли из аккаунта')
     expect(page).not_to have_content('Выйти')
   end
 end
