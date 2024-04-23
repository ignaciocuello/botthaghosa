require 'test_helper'

class CommandsTest < ActiveSupport::TestCase
  test 'set sutta for discussion session and output template' do
    sutta_abbreviation = 'MN 1'
    sutta_title = 'The Root of All Things'

    travel_to '2024-04-23'.to_date do
      assert_difference -> { Sutta.count }, 1 do
        assert_difference -> { DiscussionSession.count }, 1 do
          output = Commands.discussion_set_sutta(
            abbreviation: sutta_abbreviation,
            title: sutta_title
          )

          expected = <<~TEMPLATE
            I have noted the sutta for our next discussion on May 04 as "MN 1 - The Root of All Things".

            Here is a message that you can use to notify the community in #announcements (just click on the copy button on the top right):

            ```
            MN 1 had the most votes, so we will be studying it in our next sutta discussion on May 04.

            Don’t worry if your chosen sutta didn’t make it, we will put up unvoted suttas in subsequent polls.

            Thanks to everyone that cast their vote. 🙏🙏🙏
            ```
          TEMPLATE
          assert_equal 'MN 1', DiscussionSession.last.sutta.abbreviation
          assert_equal expected, output
        end
      end
    end
  end

  test 'set sutta discussion document' do
  end

  test 'output poll finalization template' do
  end

  test 'output notify community template' do
  end

  test 'output notify bsv template' do
  end

  test 'output template document share' do
  end
end
