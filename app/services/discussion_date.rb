# TODO: this isn't great, but it's something..
class DiscussionDate
  START_DATE = '08/04/2024'.to_date

  class << self
    def first(day_name)
      Time.use_zone('Australia/Melbourne') do
        date = discussion_schedule(day_name).next_occurrence
        format(date)
      end
    end

    def second(day_name)
      Time.use_zone('Australia/Melbourne') do
        date = discussion_schedule(day_name).next_occurrence + 1.week
        format(date)
      end
    end

    private

    # TODO: Break this out to a helper, and don't worry about formatting for this class
    # Unsure how to include helpers in the initializer.
    def format(date)
      date.strftime('%B %-d')
    end

    def discussion_schedule(day_name)
      schedule = IceCube::Schedule.new(START_DATE) do |s|
        s.add_recurrence_rule IceCube::Rule.weekly(2).day(day_name)
      end
    end
  end
end
