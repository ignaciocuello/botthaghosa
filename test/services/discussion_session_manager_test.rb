require 'test_helper'

class DiscussionSessionManagerTest < ActiveSupport::TestCase
  setup do
    travel_to '22-04-2024'.to_date
  end

  test 'create a discussion session for this fortnight if none exists' do
    assert_difference -> { DiscussionSession.count }, 1 do
      discussion_session = DiscussionSessionManager.session_for_this_fortnight

      assert_equal '2024-05-04 19:00:00'.in_time_zone, discussion_session.occurs_on
    end
  end

  test 'find the existing discussion session for this fortnight' do
    occurs_on = '2024-05-04 19:00:00'
    create(:discussion_session, occurs_on: occurs_on.in_time_zone.utc)
    assert_no_difference -> { DiscussionSession.count } do
      discussion_session = DiscussionSessionManager.session_for_this_fortnight

      assert_equal occurs_on.in_time_zone, discussion_session.occurs_on
    end
  end

  teardown do
    travel_back
  end
end
