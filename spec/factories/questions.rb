FactoryBot.define do
  factory :question do
    title { "Some question" }
    body { "Some desctription" }

    trait :invalid do
      title { nil }
    end
  end
end
