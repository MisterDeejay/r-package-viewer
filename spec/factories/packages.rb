FactoryBot.define do
  factory :package do
    sequence(:package_name) { |n| Faker::App.name << n }
    version { Faker::App.version }
    published_at { Faker::Date.backward(4000) }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.sentences }
  end
end
