require 'test_helper'

class CommandsTest < ActiveSupport::TestCase
  setup do
    travel_to '2024-04-23'.to_date
  end

  test 'set sutta for discussion session and output template' do
    assert_difference -> { Sutta.count }, 1 do
      assert_difference -> { DiscussionSession.count }, 1 do
        output = Commands.discussion_set_sutta(
          abbreviation: 'MN 1',
          title: 'The Root of All Things'
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

  test 'set sutta discussion document when session exists' do
    discussion_session = create(:discussion_session, occurs_on: '2024-05-04 19:00:00'.in_time_zone)
    sutta = create(:sutta, discussion_session:, abbreviation: 'MN 1', title: 'The Root of All Things')
    assert_difference -> { Document.count }, 1 do
      assert_no_difference -> { Sutta.count } do
        assert_no_difference -> { DiscussionSession.count } do
          output = Commands.discussion_set_document(
            link: 'https://www.google.com',
            title: '2024-05-04 MN 1'
          )

          expected = <<~TEMPLATE
            Thanks! I have noted the discussion document for our next discussion on May 04 as [2024-05-04 MN 1](https://www.google.com).
          TEMPLATE
          assert_equal 'https://www.google.com', DiscussionSession.last.document.link
          assert_equal '2024-05-04 MN 1', DiscussionSession.last.document.title
          assert_equal expected, output
        end
      end
    end
  end

  test 'output poll finalization template' do
  end

  test 'output notify community template' do
  end

  test 'output notify bsv template' do
  end

  test 'output template document share' do
  end

  teardown do
    travel_back
  end
end
