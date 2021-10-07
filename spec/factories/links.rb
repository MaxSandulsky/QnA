FactoryBot.define do
  factory :link do
    name { 'Root' }
    url { 'http://127.0.0.1:3000/questions/' }

    linkable { build(:answer) }

    trait :invalid do
      name { 'My gist' }
      url { 'MyString' }
    end
  end
end
