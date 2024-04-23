FactoryBot.define do
  factory :sutta do
    abbreviation { "DN #{rand(1..52)}" }
    title { Faker::Lorem.words }
    discussion_session
  end
end
