require 'simplecov'
SimpleCov.start 'rails' do
  enable_coverage :branch
  primary_coverage :branch
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'
require 'sidekiq/testing'

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # TODO: move to module :)
    def use_cassette(cassette_name, **opts, &block)
      VCR.use_cassette(cassette_name, **opts) do |cassette|
        travel_to cassette.originally_recorded_at || Time.zone.now do
          block.call
        end
      end
    end

    def use_erb_cassette(cassette_name, **opts, &)
      opts_with_strict_defaults = opts.with_defaults(
        allow_unused_http_interactions: false,
        match_requests_on: %i[method uri body]
      )
      use_cassette(cassette_name, **opts_with_strict_defaults, &)
    end
  end
end
