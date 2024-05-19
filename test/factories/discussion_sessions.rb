FactoryBot.define do
  factory :discussion_session do
    occurs_on { DiscussionSchedule.current(:second_saturday) }
  end
end
