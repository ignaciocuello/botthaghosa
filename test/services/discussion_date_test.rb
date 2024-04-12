require 'test_helper'

# TODO: Make intent clearer
class DiscussionDateTest < ActiveSupport::TestCase
  test 'second saturday' do
    travel_to '12-04-2024'.to_date do
      assert_equal 'April 20', DiscussionDate.second(:saturday)
    end
  end

  test 'first monday' do
    travel_to '12-04-2024'.to_date do
      assert_equal 'April 22'.to_date, DiscussionDate.first(:monday).to_date
    end
  end

  test 'second wednesday' do
    travel_to '12-04-2024'.to_date do
      assert_equal 'May 1'.to_date, DiscussionDate.second(:wednesday).to_date
    end
  end

  test 'first thursday' do
    travel_to '12-04-2024'.to_date do
      assert_equal 'April 25'.to_date, DiscussionDate.first(:thursday).to_date
    end
  end
end
