require 'test_helper'

class TemplateEngineTest < ActiveSupport::TestCase
  EXPECTED = <<~TEMPLATE
    I have noted the sutta for our next discussion on **April 20** as **"SN 56.11 - Rolling Forth the Wheel of Dhamma"**.

    Here is a message that you can use to notify the community in #announcements (just click on the copy button on the top right):

    ```
    SN 56.11 had the most votes, so we will be studying it in our next sutta discussion on April 20.

    Don’t worry if your chosen sutta didn’t make it, we will put up unvoted suttas in subsequent polls.

    Thanks to everyone that cast their vote. 🙏🙏🙏
    ```
  TEMPLATE
             .freeze

  test 'fill template' do
    output = TemplateEngine.generate(:set_sutta,
                                     sutta_abbreviation: 'SN 56.11',
                                     sutta_full_title: 'SN 56.11 - Rolling Forth the Wheel of Dhamma',
                                     discussion_date: 'April 20')

    assert_equal EXPECTED, output
  end

  test 'fill template with default args' do
    travel_to '12-04-2024'.to_date do
      discussion_session = create(:discussion_session, occurs_on: '2024-04-20 19:00:00'.in_time_zone)
      create(:sutta,
             discussion_session:,
             abbreviation: 'SN 56.11',
             title: 'Rolling Forth the Wheel of Dhamma')

      output = TemplateEngine.generate(:set_sutta)

      assert_equal EXPECTED, output
    end
  end

  test 'fill template with no sutta set' do
    output = TemplateEngine.generate(:set_sutta)

    assert output.include?('[NO SUTTA SET]')
  end

  test 'filling empty template returns nil' do
    output = TemplateEngine.generate(:non_existent, sutta_abbreviation: 'MN 11')

    assert_nil output
  end
end
