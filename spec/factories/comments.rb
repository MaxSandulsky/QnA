FactoryBot.define do
  factory :comment do
    text { 'MyString' }

    author factory: :user
    commentable { build(:answer) }
  end
end
