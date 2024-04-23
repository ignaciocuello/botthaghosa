require 'test_helper'

# TODO: DRY up this test
class DiscussionSessionManagerTest < ActiveSupport::TestCase
  setup do
    travel_to '21-04-2024'.to_date
  end

  test 'set sutta for discussion session and create if none exists' do
    assert_difference -> { Sutta.count }, 1 do
      assert_difference -> { DiscussionSession.count }, 1 do
        discussion_session = DiscussionSessionManager.set_sutta_for_this_fortnight(
          abbreviation: 'MN 1',
          title: 'The Root of All Things'
        )

        assert_equal 'MN 1', discussion_session.sutta.abbreviation
        assert_equal 'The Root of All Things', discussion_session.sutta.title
      end
    end
  end

  test 'set sutta for existing discussion session' do
    occurs_on = '2024-05-04 19:00:00'
    existing = create(:discussion_session, occurs_on: occurs_on.in_time_zone.utc)
    sutta = create(
      :sutta,
      discussion_session: existing,
      abbreviation: 'MN 1',
      title: 'The Root of All Things'
    )

    assert_no_difference -> { Sutta.count } do
      assert_no_difference -> { DiscussionSession.count } do
        discussion_session = DiscussionSessionManager.set_sutta_for_this_fortnight(
          abbreviation: 'MN 2',
          title: 'All The Taints'
        )
        assert_equal 'MN 2', discussion_session.sutta.abbreviation
        assert_equal 'All The Taints', discussion_session.sutta.title
        assert_not Sutta.exists?(sutta.id)
      end
    end
  end

  test 'set document for discussion session and create if none exists' do
    assert_difference -> { Document.count }, 1 do
      assert_difference -> { DiscussionSession.count }, 1 do
        discussion_session = DiscussionSessionManager.set_document_for_this_fortnight(
          link: 'docs.google.com/document/123'
        )

        assert_equal '04-05-24', discussion_session.document.title
        assert_equal 'docs.google.com/document/123', discussion_session.document.link
      end
    end
  end

  test 'set document for existing discussion session' do
    occurs_on = '2024-05-04 19:00:00'
    existing = create(:discussion_session, occurs_on: occurs_on.in_time_zone.utc)
    sutta = create(:sutta, discussion_session: existing, abbreviation: 'MN 9')
    document = create(
      :document,
      discussion_session: existing,
      link: 'docs.google.com/document/123'
    )

    assert_no_difference -> { Document.count } do
      assert_no_difference -> { DiscussionSession.count } do
        discussion_session = DiscussionSessionManager.set_document_for_this_fortnight(
          link: 'docs.google.com/document/456'
        )

        assert_equal '04-05-24 MN 9', discussion_session.document.title
        assert_equal 'docs.google.com/document/456', discussion_session.document.link
        assert_not Document.exists?(document.id)
      end
    end
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
