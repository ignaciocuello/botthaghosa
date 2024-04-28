require 'test_helper'

class DiscussionSessionTest < ActiveSupport::TestCase
  test 'invalid without an occurs on' do
    discussion_session = build(:discussion_session, occurs_on: nil)

    assert_predicate discussion_session, :invalid?
  end

  test 'invalid for duplicate occurs on' do
    datetime = Time.zone.now
    discussion_session = create(:discussion_session, occurs_on: datetime)
    duplicate_discussion_session = build(:discussion_session, occurs_on: datetime)

    assert_predicate duplicate_discussion_session, :invalid?
  end

  test 'valid with all attributes' do
    discussion_session = build(:discussion_session)

    assert_predicate discussion_session, :valid?
  end

  test 'set sutta' do
    assert_difference -> { Sutta.count }, 1 do
      discussion_session = create(:discussion_session)
      discussion_session.set_sutta(abbreviation: 'MN 1', title: 'The Root of All Things')

      assert_equal 'MN 1', discussion_session.sutta.abbreviation
      assert_equal 'The Root of All Things', discussion_session.sutta.title
    end
  end

  test 'set sutta, destroy any previously set sutta' do
    discussion_session = create(:discussion_session, sutta: create(:sutta))
    old_sutta = discussion_session.sutta

    discussion_session.set_sutta(abbreviation: 'MN 1', title: 'The Root of All Things')

    assert_predicate old_sutta, :destroyed?
    assert_equal 'MN 1', discussion_session.sutta.abbreviation
  end

  test 'set document' do
    assert_difference -> { Document.count }, 1 do
      discussion_session = create(:discussion_session, occurs_on: '2024-05-04 19:00:00')
      discussion_session.set_document(link: 'docs.google.com/document/123')

      assert_equal '04-05-24', discussion_session.document.title
      assert_equal 'docs.google.com/document/123', discussion_session.document.link
    end
  end

  test 'set document when sutta set' do
    discussion_session = create(
      :discussion_session,
      occurs_on: '2024-05-04 19:00:00',
      sutta: create(:sutta, abbreviation: 'MN 5')
    )
    discussion_session.set_document(link: 'docs.google.com/document/123')

    assert_equal '04-05-24 MN 5', discussion_session.document.title
    assert_equal 'docs.google.com/document/123', discussion_session.document.link
  end

  test 'set document, destroy any previously set document' do
    discussion_session = create(:discussion_session, document: create(:document))
    old_document = discussion_session.document

    discussion_session.set_document(link: 'docs.google.com/document/123')

    assert_predicate old_document, :destroyed?
    assert_equal 'docs.google.com/document/123', discussion_session.document.link
  end
end
