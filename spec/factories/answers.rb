FactoryBot.define do
  sequence :body do |n|
    "Answer text#{n}"
  end

  factory :answer do
    body
    question { nil }
    association :user_id, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end