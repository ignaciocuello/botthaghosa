require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  test 'invalid without a title' do
    document = build(:document, title: nil)

    assert_predicate document, :invalid?
  end

  test 'invalid with a duplicate title' do
    document = create(:document, title: '24-09-1997 MN 2')
    duplicate_document = build(:document, title: '24-09-1997 MN 2')

    assert_predicate duplicate_document, :invalid?
  end

  test 'valid with all attributes' do
    document = build(:document)

    assert_predicate document, :valid?
  end
end
