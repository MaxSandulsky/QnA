FactoryBot.define do
  factory :answer do
    body { 'Some answer' }

    question
    author factory: :user

    trait :invalid do
      body { nil }
    end
  end
end
