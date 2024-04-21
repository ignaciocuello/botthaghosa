FactoryBot.define do
  factory :sutta do
    abbreviation { "MN #{rand(1..152)}" }
    title { Faker::Lorem.words }
    discussion_session
  end
end
