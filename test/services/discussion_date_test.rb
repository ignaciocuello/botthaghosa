require 'test_helper'

# TODO: Make intent clearer
class DiscussionDateTest < ActiveSupport::TestCase
  test 'second saturday' do
    travel_to '12-04-2024'.to_date do
      assert_equal '20-04-2024'.to_date, DiscussionDate.second(:saturday).to_date
    end
  end

  test 'first monday' do
    travel_to '12-04-2024'.to_date do
      assert_equal '22-04-2024'.to_date, DiscussionDate.first(:monday).to_date
    end
  end

  test 'second wednesday' do
    travel_to '12-04-2024'.to_date do
      assert_equal '01-05-2024'.to_date, DiscussionDate.second(:wednesday).to_date
    end
  end

  test 'first thursday' do
    travel_to '12-04-2024'.to_date do
      assert_equal '25-04-2024'.to_date, DiscussionDate.first(:thursday).to_date
    end
  end
end
