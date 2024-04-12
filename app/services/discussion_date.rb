class DiscussionDate
  START_DATE = '08/04/2024'.to_date

  class << self
    def first(day_name)
      discussion_schedule(day_name).next_occurrence
    end

    def second(day_name)
      discussion_schedule(day_name).next_occurrence + 1.week
    end

    private

    def discussion_schedule(day_name)
      schedule = IceCube::Schedule.new(START_DATE) do |s|
        s.add_recurrence_rule IceCube::Rule.weekly(2).day(day_name)
      end
    end
  end
end
