FactoryBot.define do
  sequence :body do |n|
    "Answer text#{n}"
  end

  factory :answer do
  end
end
