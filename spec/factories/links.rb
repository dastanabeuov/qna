FactoryBot.define do
  factory :link do
    name { "Google" }
    url { "https://google.com" }

    trait :invalid_link do
      url { "htt://google.com" }
    end
  end
end
