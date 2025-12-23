FactoryBot.define do
  factory :asana do
    title { Faker::Lorem.words(number: 2).join(" ") }
    benefits { Faker::Lorem.paragraph }
    contraindications { Faker::Lorem.sentence }
    into_pose { Faker::Lorem.paragraph }
    out_of_pose { Faker::Lorem.paragraph }
    recommended_time { "3-5 minutes" }
  end
end
