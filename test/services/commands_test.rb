require 'test_helper'

class CommandsTest < ActiveSupport::TestCase
  setup do
    travel_to '2024-04-23'.to_date
    create(:admin, email: 'sutta-group@bsv.net.au')
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

  test 'get sutta discussion session document when session exists' do
    create_session(with_document: true)

    output = Commands.discussion_get_session_document
    assert_includes output, '04-05-24 MN 1'
  end

  test 'get sutta discussion document when session does not exist' do
    output = Commands.discussion_get_session_document
    assert_includes output, '[NO SESSION DOCUMENT SET]'
  end

  test 'output notify community template' do
    create_session
    assert_includes Commands.discussion_template_notify_community, 'Join us on Zoom'
  end

  test 'output notify bsv template' do
    create_session
    assert_includes Commands.discussion_template_notify_bsv, 'Just posting the link'
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
    if with_document
      create(:document, :session, title: '04-05-24 MN 1', discussion_session:,
                                  link: 'https://www.google.com')
    end
    discussion_session
  end
end
