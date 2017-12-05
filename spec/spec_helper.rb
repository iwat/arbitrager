# frozen_string_literal: true

require File.expand_path('../../config/boot', __FILE__)

require 'pry'
require 'webmock/rspec'

require 'arbitrager'
require 'bitbot'
require 'exchange'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |expectation|
    expectation.syntax = :expect
    expectation.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
