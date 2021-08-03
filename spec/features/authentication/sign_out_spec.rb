feature "User can sign out", %q{
  In order to exit
  As authenticated user
  I'd like to be able to sign out
 } do
   given(:user) { create(:user) }

   scenario "Authenticated user tries to sign out" do
     login user

     click_link('Выйти')

     expect(page).to have_content('Вы вышли из аккаунта')
     expect(page).not_to have_content('Выйти')
   end
 end
