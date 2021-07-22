FactoryBot.define do
  factory :answer do
    body { "Some answer" }
    question factory: :question
  end
end
