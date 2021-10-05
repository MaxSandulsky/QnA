FactoryBot.define do
  factory :reward do
    name { "MyString" }

    picture { Rack::Test::UploadedFile.new('spec/support/test_image.jpg', 'test_image.jpg') }

    question
  end
end
