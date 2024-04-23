require 'test_helper'

class TemplateEngineTest < ActiveSupport::TestCase
  EXPECTED = <<~TEMPLATE
    ```
    SN 56.11 had the most votes, so we will be studying it in our next sutta discussion on April 20.

    Don’t worry if your chosen sutta didn’t make it, we will put up unvoted suttas in subsequent polls.

    Thanks to everyone that cast their vote. 🙏🙏🙏
    ```
  TEMPLATE
             .freeze

  test 'fill template' do
    output = TemplateEngine.generate(:poll_finalize, sutta_id: 'SN 56.11', discussion_date: 'April 20')

    assert_equal EXPECTED, output
  end

  test 'fill template with default args' do
    travel_to '12-04-2024'.to_date do
      discussion_session = create(:discussion_session, occurs_on: '2024-04-20 19:00:00'.in_time_zone)
      create(:sutta, discussion_session:, abbreviation: 'SN 56.11')

      output = TemplateEngine.generate(:poll_finalize)

      assert_equal EXPECTED, output
    end
  end

  test 'fill template with no sutta set' do
    output = TemplateEngine.generate(:poll_finalize)

    assert output.include?('[NO SUTTA SET]')
  end

  test 'filling empty template returns nil' do
    output = TemplateEngine.generate(:non_existent, sutta_id: 'MN 11')

    assert_nil output
  end
end
