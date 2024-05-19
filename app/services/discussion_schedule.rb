class DiscussionSchedule
  DAYNAMES_FROM_MONDAY = Date::DAYNAMES.rotate.map(&:downcase)
  FIRST_PERIOD_END = 'Monday 2024-04-08 00:00:00'.in_time_zone

  class << self
    def current(day_of_period)
      day_of_period = :second_saturday if day_of_period == :session_date
      week_position, day_name = day_of_period.to_s.split('_')

      week_offset = week_position == 'first' ? 0 : 1
      day_offset = DAYNAMES_FROM_MONDAY.find_index(day_name)

      period_end = discussion_schedule.next_occurrence
      period_start = period_end - 2.weeks

      (period_start + week_offset.weeks + day_offset.days + 19.hours).utc
    end

    def current?(day_of_period)
      Time.zone.today.day == current(day_of_period).day
    end

    private

    def discussion_schedule
      schedule = IceCube::Schedule.new(FIRST_PERIOD_END) do |s|
        s.add_recurrence_rule IceCube::Rule.weekly(2)
      end
    end
  end
end
