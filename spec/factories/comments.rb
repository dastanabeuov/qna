FactoryBot.define do
  factory :comment do
    user { nil }
    commentable_id { 1 }
    commentable_type { "MyString" }
    text { "MyText" }
  end
end
