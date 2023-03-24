FactoryBot.define do
  factory :vendor do
    sequence(:id) { |n| n }
    name { "MyString" }
    sequence(:email) { |n| "testy_#{n}@tester.com" }
    description { "MyText" }
    api_endpoint { "MyString" }
    api_key { "MyString" }
  end
end
