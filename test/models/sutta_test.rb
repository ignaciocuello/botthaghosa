require 'test_helper'

class SuttaTest < ActiveSupport::TestCase
  test 'invalid without an abbreviation' do
    sutta = build(:sutta, abbreviation: nil)

    assert_predicate sutta, :invalid?
  end

  test 'invalid when abbreviation is not unique' do
    sutta = create(:sutta, abbreviation: 'MN 1')
    duplicate_sutta = build(:sutta, abbreviation: 'MN 1')

    assert_predicate duplicate_sutta, :invalid?
  end

  test 'valid with all attributes' do
    sutta = build(:sutta)

    assert_predicate sutta, :valid?
  end

  test 'full title' do
    sutta = build(:sutta, abbreviation: 'MN 1', title: 'The Root of All Things')

    assert_equal 'MN 1 - The Root of All Things', sutta.full_title
  end

  test 'full title is just abbreviation when no official title' do
    sutta = build(:sutta, abbreviation: 'MN 1', title: nil)

    assert_equal 'MN 1', sutta.full_title
  end
end
