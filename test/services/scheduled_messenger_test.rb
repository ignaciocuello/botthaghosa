require 'test_helper'

class ScheduledMessengerTest < ActiveSupport::TestCase
  setup do
    travel_to 'Monday 20/05/2024'.to_date do
      session = create(:discussion_session)
      session.update!(
        logistics_user_id: Rails.application.credentials.dig(:discord, :debug_user_id)
      )
    end
  end

  test 'attempt send succeeds on first monday' do
    travel_to 'Monday 20/05/2024'.to_date do
      success = ScheduledMessenger.attempt_send
      assert success
    end
  end

  test 'attempt send succeeds on second monday' do
    travel_to 'Monday 27/05/2024'.to_date do
      VCR.use_cassette('second monday attempt') do
        success = ScheduledMessenger.attempt_send
        assert success
      end
    end
  end

  test 'attempt send succeeds on second wednesday' do
    travel_to 'Wednesday 29/05/2024'.to_date do
      VCR.use_cassette('second wednesday attempt') do
        success = ScheduledMessenger.attempt_send
        assert success
      end
    end
  end

  test 'attempt send fails on other days' do
    travel_to 'Saturday 25/05/2024'.to_date do
      success = ScheduledMessenger.attempt_send
      assert_not success
    end
  end
end
