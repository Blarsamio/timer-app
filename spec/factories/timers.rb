FactoryBot.define do
  factory :timer do
    duration { Faker::Number.between(from: 60, to: 600) }
    title { Faker::Lorem.word }
    session
  end
end
