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
    create_session

    assert_difference -> { Document.count }, 1 do
      assert_no_difference -> { Sutta.count } do
        assert_no_difference -> { DiscussionSession.count } do
          output = Commands.discussion_set_document(
            link: 'https://www.google.com',
          )

          expected = <<~TEMPLATE
            Thanks! I have noted the discussion document for our next discussion on May 04 as [04-05-24 MN 1](https://www.google.com).
          TEMPLATE
          assert_equal 'https://www.google.com', DiscussionSession.last.document.link
          assert_equal '04-05-24 MN 1', DiscussionSession.last.document.title
          assert_equal expected, output
        end
      end
    end
  end

  test 'output poll finalization template' do
    create_session
    output = Commands.template_poll_finalize

    expected = <<~TEMPLATE
        ```
        MN 1 had the most votes, so we will be studying it in our next sutta discussion on May 04.

        Don’t worry if your chosen sutta didn’t make it, we will put up unvoted suttas in subsequent polls.

        Thanks to everyone that cast their vote. 🙏🙏🙏
        ```
    TEMPLATE
    assert_equal expected, output
  end

  test 'output notify community template' do
    create_session

    output = Commands.template_notify_community
    expected = <<~TEMPLATE
    ```
    Hey everyone! :wave:

    Just a quick heads up about our sutta discussion this **Saturday at 7PM** on **MN 1 - The Root of All Things**. It's a great opportunity to dive into some deep Buddhist teachings and share your thoughts.

    Join us on Zoom [here](#{Rails.application.credentials.dig(:zoom, :session_link)}). Hope to see you there for a meaningful and engaging conversation!
    ```
    TEMPLATE
  end

  test 'output template document share' do
    create_session(with_document: true)

    output = Commands.template_document_share
    expected = <<~TEMPLATE
      ```
      Hey everyone! :wave: Here’s the link to the session document for our upcoming sutta discussion happening this Saturday at 7PM! :clock7: 

      - [MN 1 - The Root of All Things](https://www.google.com)

      Looking forward to seeing you there!
      ```
    TEMPLATE
    assert_equal expected, output
  end

  teardown do
    travel_back
  end

  private 

  def create_session(with_document: false)
    discussion_session = create(:discussion_session, occurs_on: '2024-05-04 19:00:00'.in_time_zone)
    sutta = create(:sutta, discussion_session:, abbreviation: 'MN 1', title: 'The Root of All Things')
    create(:document, title: '04-05-24 MN 1', discussion_session:, link: 'https://www.google.com') if with_document
    discussion_session
  end
end
