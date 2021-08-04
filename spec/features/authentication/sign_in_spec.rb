describe 'User can sign in', "
  In order to ask questions
  As unauthenticated user
  I'd like to be able to sign in
 " do
   let(:user) { create(:user) }

   before { visit new_user_session_path }

   it 'Registered user tries to sign in' do
     fill_in 'Email', with: user.email
     fill_in 'Password', with: user.password
     click_on 'Log in'

     expect(page).to have_content 'Добро пожаловать!'
   end

   it 'Unregistered user tries to sign in' do
     fill_in 'Email', with: 'wrong@mail.com'
     fill_in 'Password', with: ' '
     click_on 'Log in'

     expect(page).to have_content 'Forgot your password?'
   end
 end
