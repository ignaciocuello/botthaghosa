FactoryBot.define do
  factory :admin do
    email { Faker::Internet.email }
    password { SecureRandom.uuid }
  end
end
