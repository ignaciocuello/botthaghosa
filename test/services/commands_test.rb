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

        assert_includes output, 'MN 1 - The Root of All Things'
      end
    end
  end

  test 'set sutta discussion document when session exists' do
    create_session

    assert_difference -> { Document.count }, 1 do
      assert_no_difference -> { Sutta.count } do
        assert_no_difference -> { DiscussionSession.count } do
          output = Commands.discussion_set_document(
            link: 'https://www.google.com'
          )

          assert_includes output, '[04-05-24 MN 1](https://www.google.com)'
          assert_equal 'https://www.google.com', DiscussionSession.last.document.link
          assert_equal '04-05-24 MN 1', DiscussionSession.last.document.title
        end
      end
    end
  end

  test 'get sutta discussion document when session exists' do
    create_session(with_document: true)

    output = Commands.discussion_get_document
    assert_includes output, '04-05-24 MN 1'
  end

  test 'get sutta discussion document when session does not exist' do
    output = Commands.discussion_get_document
    assert_includes output, '[NO DOCUMENT SET]'
  end

  test 'output notify community template' do
    create_session
    assert_includes Commands.discussion_template_notify_community, 'Join us on Zoom'
  end

  test 'output template document share' do
    create_session(with_document: true)
    assert_includes Commands.discussion_template_document_share, 'Looking forward to seeing you there!'
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
