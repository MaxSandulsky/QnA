feature 'User can sign up', "
  In order to ask questions
  As unauthenticated user
  I'd like to be able to sign up
 " do
   background { visit new_user_registration_path }

   let(:user) { create(:user) }

   it 'Unregistered user tries to sign up' do
     fill_in 'Email', with: 'new_user@email'
     fill_in 'Password', with: 'new_user.password'
     fill_in 'Password confirmation', with: 'new_user.password'
     click_on 'Sign up'

     expect(page).to have_content 'Добро пожаловать!'
   end

   it 'Registered user tries to sign up' do
     fill_in 'Email', with: user.email
     fill_in 'Password', with: '12345678'
     fill_in 'Password confirmation', with: '12345678'
     click_on 'Sign up'

     expect(page).to have_content 'Аккаунт с таким именем уже существует!'
   end
 end
