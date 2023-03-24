FactoryBot.define do
  factory :customer do
    sequence(:id) { |n| n }
    sequence(:name) { |n| "Company_#{n}" }
    sequence(:email) { |n| "testy_#{n}@tester.com" }
    description { "MyText" }
    api_endpoint { "MyString" }
    api_key { "MyString" }
  end
end
