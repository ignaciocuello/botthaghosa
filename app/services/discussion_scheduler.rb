# TODO: this isn't great, but it's something..
class DiscussionScheduler
  # NOTE: not obvious this is Saturday
  START_DATETIME = '2024-04-06 19:00:00'.to_time

  class << self
    def next_occurrence
      discussion_schedule.next_occurrence.in_time_zone
    end

    private

    def discussion_schedule
      schedule = IceCube::Schedule.new(START_DATETIME) do |s|
        s.add_recurrence_rule IceCube::Rule.weekly(2)
      end
    end
  end
end
