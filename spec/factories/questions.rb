FactoryBot.define do
  sequence :title do |n|
    "Some question #{n}"
  end

  factory :question do
    title { 'Some question' }
    body { 'Some description' }

    author factory: :user

    factory :question_with_answers do
      title { 'Some question with answers' }
      transient do
        answers_count { 5 }
      end

      answers do
        Array.new(answers_count) { association(:answer) }
      end
    end

    factory :question_with_rewards do
      title { 'Some question with rewards' }

      reward do
        association(:reward)
      end
    end

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
