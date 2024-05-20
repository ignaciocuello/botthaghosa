require 'test_helper'

class CommandsTest < ActiveSupport::TestCase
  setup do
    travel_to '2024-04-23'.to_date
    create(:admin, email: 'sutta-group@bsv.net.au')
  end

  test 'start discussion preparation' do
    assert_difference -> { CopyTasksTemplateJob.jobs.size }, 1 do
      assert_difference -> { DiscussionSession.count }, 1 do
        output = Commands.discussion_start_preparation

        assert_includes output, 'On it!'
      end
    end
  end

  test 'set sutta for discussion session and output template' do
    session = create_session(with_sutta: false)

    assert_difference -> { CopySuttaTemplateJob.jobs.size }, 1 do
      assert_difference -> { Sutta.count }, 1 do
        assert_changes -> { session.reload.logistics_user_id }, from: nil do
          output = Commands.discussion_set_sutta(
            abbreviation: 'MN 1',
            title: 'The Root of All Things',
            logistics_user_id: '123'
          )

          assert_includes output, 'MN 1 - The Root of All Things'
        end
      end
    end
  end

  test 'get sutta discussion session links when session exists' do
    create_session(with_document: true)

    output = Commands.discussion_get_session_links
    assert_includes output, '04-05-24 MN 1'
  end

  test 'get sutta discussion links when session does not exist' do
    output = Commands.discussion_get_session_links
    assert_includes output, '[NO SESSION DOCUMENT SET]'
  end

  teardown do
    travel_back
  end

  private

  def create_session(with_sutta: true, with_document: false)
    discussion_session = create(:discussion_session, occurs_on: '2024-05-04 19:00:00'.in_time_zone)
    if with_sutta
      sutta = create(:sutta, discussion_session:, abbreviation: 'MN 1',
                             title: 'The Root of All Things')
    end
    if with_document
      create(:document, :session, title: '04-05-24 MN 1', discussion_session:,
                                  link: 'https://www.google.com')
    end
    discussion_session
  end
end
