FactoryBot.define do
  factory :discussion_session do
    occurs_on { Time.zone.today }
  end
end
