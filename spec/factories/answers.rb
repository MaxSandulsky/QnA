FactoryBot.define do
  factory :answer do
    body { "Some answer" }

    question

    trait :invalid do
      body { nil }
    end
  end
end
