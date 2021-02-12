FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    title
    body { "MyText" }
    
    trait :file do
      files { Rack::Test::UploadedFile.new('spec/support/test.txt', 'text/plain') }
    end

    trait :invalid do
      title { nil }
    end
  end
end