FactoryBot.define do
  factory :session do
    name { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
  end
end
