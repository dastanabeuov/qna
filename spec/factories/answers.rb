FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end

  factory :answer do
    body
  
    trait :invalid do
      body { nil }
    end

    trait :file do
      files { Rack::Test::UploadedFile.new('spec/support/test.txt', 'text/plain') }
    end
  end
end
