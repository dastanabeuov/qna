FactoryBot.define do
  factory :link do
    name { "Google" }
    url { "https://google.com" }
    linkable_id { 1 }
    linkable_type { "MyString" }
    trait :invalid_link do
      url { "htt://google.com" }
    end
  end
end
