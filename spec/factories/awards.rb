FactoryBot.define do
  sequence :award_title do |n|
    "Award#{n}"
  end

  factory :award do
    title { sequence :award_title }
    image { Rack::Test::UploadedFile.new('spec/support/image.png') }
    trait :invalid do
      image { nil }
    end
  end
end