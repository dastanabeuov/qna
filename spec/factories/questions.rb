FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    title
    body { "MyText" }
    association :user_id, factory: :user

    trait :invalid do
      title { nil }
    end
  end
end
