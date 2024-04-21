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
end
