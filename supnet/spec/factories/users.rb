FactoryBot.define do

  factory :user do
    sequence(:id) { |n| n }
    sequence(:email) { |n| "testy_#{n}@tester.com" }
    sequence(:name) { |n| "Testy_#{n} McTesterson" }
    password { "qwerty" }
  end

end
