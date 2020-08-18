FactoryBot.define do
  sequence :award_title do |n|
    "Award#{n}"
  end

  factory :award do
    award_title
    image { Rack::Test::UploadedFile.new('spec/support/image.png') }
  end

  trait :invalid_img do
    image { nil }
  end
end