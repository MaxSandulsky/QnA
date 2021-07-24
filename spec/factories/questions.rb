FactoryBot.define do
  factory :question do
    title { "Some question" }
    body { "Some desctription" }

    factory :question_with_answers do
      transient do
        answers_count { 5 }
      end

      answers do
        Array.new(answers_count) { association(:answer) }
      end
    end

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
