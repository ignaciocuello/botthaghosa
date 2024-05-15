require 'test_helper'

class DiscussionScheduleTest < ActiveSupport::TestCase
  test 'session date for Friday April 12' do
    travel_to '2024-04-12'.to_date do
      datetime = DiscussionSchedule.current(:session_date)
      assert_equal '2024-04-20 19:00:00'.in_time_zone.utc, datetime
    end
  end

  test 'session date for Monday April 15' do
    travel_to '2024-04-15'.to_date do
      datetime = DiscussionSchedule.current(:session_date)
      assert_equal '2024-04-20 19:00:00'.in_time_zone.utc, datetime
    end
  end

  test 'session date for Saturday April 20' do
    travel_to '2024-04-20'.to_date do
      datetime = DiscussionSchedule.current(:session_date)
      assert_equal '2024-04-20 19:00:00'.in_time_zone.utc, datetime
    end
  end

  test 'session date for Monday April 22' do
    travel_to '2024-04-22'.in_time_zone.utc do
      datetime = DiscussionSchedule.current(:session_date)
      assert_equal '2024-05-04 19:00:00'.in_time_zone.utc, datetime
    end
  end

  test 'First Monday for Monday April 22' do
    travel_to '2024-04-22'.in_time_zone.utc do
      datetime = DiscussionSchedule.current(:first_monday)
      assert_equal '2024-04-22 19:00:00'.in_time_zone.utc, datetime
    end
  end

  test 'First Wednesday for Monday April 22' do
    travel_to '2024-04-22'.in_time_zone.utc do
      datetime = DiscussionSchedule.current(:first_wednesday)
      assert_equal '2024-04-24 19:00:00'.in_time_zone.utc, datetime
    end
  end

  test 'Second Monday for Monday April 22' do
    travel_to '2024-04-22'.in_time_zone.utc do
      datetime = DiscussionSchedule.current(:second_monday)
      assert_equal '2024-04-29 19:00:00'.in_time_zone.utc, datetime
    end
  end

  test 'Second Wednesday for Monday April 22' do
    travel_to '2024-04-22'.in_time_zone.utc do
      datetime = DiscussionSchedule.current(:second_wednesday)
      assert_equal '2024-05-01 19:00:00'.in_time_zone.utc, datetime
    end
  end

  test 'Second Sunday for Monday April 22' do
    travel_to '2024-04-22'.in_time_zone.utc do
      datetime = DiscussionSchedule.current(:second_sunday)
      assert_equal '2024-05-05 19:00:00'.in_time_zone.utc, datetime
    end
  end
end
