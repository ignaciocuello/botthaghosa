require 'test_helper'

class BotthaghosaTest < ActiveSupport::TestCase
  # NOTE: what are we actually testing here?
  # TODO: prevent output to stdout

  test 'set up commands' do
    VCR.use_cassette('setup commands', allow_unused_http_interactions: false) do |cassette|
      travel_to cassette.originally_recorded_at || Time.zone.now do
        bot = Botthaghosa.new
        bot.setup_commands
      end
    end
  end

  test 'run in background' do
    VCR.use_cassette('run in background', allow_unused_http_interactions: false) do |cassette|
      travel_to cassette.originally_recorded_at || Time.zone.now do
        bot = Botthaghosa.new
        bot.run_in_background
        bot.stop
      end
    end
  end

  test 'send message' do
    VCR.use_cassette('send message', match_requests_on: %i[method uri body],
                                     erb: { content: 'Hello there.' }) do |cassette|
      travel_to cassette.originally_recorded_at || Time.zone.now do
        bot = Botthaghosa.new
        bot.run_in_background
        bot.send_message('Hello there.')
        bot.stop
      end
    end
  end
end
