require 'test_helper'

class TemplateTest < ActiveSupport::TestCase
  test 'fill template for poll finalize' do
    travel_to '12-04-2024'.to_date do
      template = Template.new(:poll_finalize)
      filled = template.fill(sutta_id: 'SN 56.11')

      expected = <<~TEMPLATE
        ```
        SN 56.11 had the most votes, so we will be studying it in our next sutta discussion on April 20.

        Don’t worry if your chosen sutta didn’t make it, we will put up unvoted suttas in subsequent polls.

        Thanks to everyone that cast their vote. 🙏🙏🙏
        ```
      TEMPLATE

      assert_equal expected, filled
    end
  end

  test 'fill template for notifying community' do
    template = Template.new(:notify_community)
    filled = template.fill(sutta_id: 'MN 11')

    expected = <<~TEMPLATE
      ```
      Hey everyone! :wave:

      Just a quick heads up about our sutta discussion this **Saturday at 7PM** on **MN 11**. It's a great opportunity to dive into some deep Buddhist teachings and share your thoughts.

      Join us on Zoom [here](#{Rails.application.credentials.dig(:zoom, :session_link)}). Hope to see you there for a meaningful and engaging conversation!
      ```
    TEMPLATE

    assert_equal expected, filled
  end

  test 'filling empty template returns nil' do
    template = Template.new(:non_existent)
    filled = template.fill(sutta_id: 'MN 11')

    assert_nil filled
  end
end
