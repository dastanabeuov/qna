FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { "MyString" }
    uid { "" }
  end
end
