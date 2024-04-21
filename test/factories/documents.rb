FactoryBot.define do
  factory :document do
    title { "#{Time.zone.today.strftime('%d-%m-%y')} MN #{rand(1..152)}" }
    link { Faker::Internet.url }
  end
end
