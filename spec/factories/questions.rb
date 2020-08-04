FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    title
    body { "MyText" }
  end

  trait :invalid_ques do
    title { nil }
  end

  trait :from_question_file do
    files { Rack::Test::UploadedFile.new('spec/support/test.txt', 'text/plain') }
  end  
end