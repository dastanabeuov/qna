FactoryBot.define do
  sequence :body do |n|
    "Answer text#{n}"
  end

  factory :answer do
    body
  end

  trait :invalid_ans do
    body { nil }
  end

  trait :from_file do
    files { Rack::Test::UploadedFile.new('spec/support/test.txt', 'text/plain') }
  end  
end
