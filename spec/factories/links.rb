FactoryBot.define do
  factory :link do
    name { "My gist" }
    url { "https://gist.github.com/MaxSandulsky/659290bad6df910b28d514bed4cfd22a" }

    linkable { build(:answer) }

    trait :invalid do
      name { "My gist" }
      url { "MyString" }
    end
  end
end
