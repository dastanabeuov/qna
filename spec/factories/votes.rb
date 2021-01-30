FactoryBot.define do
  factory :vote do
    value { 1 }
    votable_id { 1 }
    votable_type { 'MyString' }
    user_id { nil }
  end
end