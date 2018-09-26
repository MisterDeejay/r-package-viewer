FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    sequence(:email) { |n| Faker::Internet.email << n }
  end
end
