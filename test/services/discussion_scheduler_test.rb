require 'test_helper'

# TODO: Make intent clearer
class DiscussionSchedulerTest < ActiveSupport::TestCase
  test 'next occurrence for Friday April 12' do
    travel_to '2024-04-12'.to_date do
      datetime = DiscussionScheduler.next_occurrence
      assert_equal '2024-04-20 19:00:00'.in_time_zone, datetime
    end
  end

  test 'next occurrence for Monday April 15' do
    travel_to '2024-04-15'.to_date do
      datetime = DiscussionScheduler.next_occurrence
      assert_equal '2024-04-20 19:00:00'.in_time_zone, datetime
    end
  end

  test 'next occurrence for Saturday April 20 before 7PM' do
    travel_to '2024-04-20 18:00:00'.in_time_zone do
      datetime = DiscussionScheduler.next_occurrence
      assert_equal '2024-04-20 19:00:00'.in_time_zone, datetime
    end
  end

  test 'next occurrence for Saturday April 20 after 7PM' do
    travel_to '2024-04-20 20:00:00'.in_time_zone do
      datetime = DiscussionScheduler.next_occurrence
      assert_equal '2024-05-04 19:00:00'.in_time_zone, datetime
    end
  end

  test 'next occurrence for Monday April 22' do
    travel_to '2024-04-22'.in_time_zone do
      datetime = DiscussionScheduler.next_occurrence
      assert_equal '2024-05-04 19:00:00'.in_time_zone, datetime
    end
  end
end
