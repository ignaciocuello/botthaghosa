require 'simplecov'
SimpleCov.start 'rails' do
  enable_coverage :branch
  primary_coverage :branch
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)
  end
end
