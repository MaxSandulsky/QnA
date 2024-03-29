FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { 'somePassword' }
    password_confirmation { 'somePassword' }
  end
end
