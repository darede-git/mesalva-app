# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
abort('Rails is running in production mode!') if Rails.env.production?
require 'simplecov'
require 'rspec/rails'
require 'factory_bot_rails'
require 'shoulda/matchers'
require 'database_cleaner'
require 'devise'
require 'vcr'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].sort.each { |f| require f }
Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].sort.each { |f| require f }
Dir["#{File.dirname(__FILE__)}../app/helpers/**/*.rb"].sort.each { |f| require f }

SimpleCov.start
Fog.mock!

ActiveRecord::Migration.maintain_test_schema!
# rubocop:disable Style/MixinUsage
include JsonAPIHelper
include RequestHelpers
include SerializationHelper
include JsonResponseHelper
include StubHelper
# rubocop:enable Style/MixinUsage

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do |_example|
    Timecop.return
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.include Devise::TestHelpers, type: :controller
  config.include_context 'users'
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.before_record do |i|
    i.response.body.force_encoding('UTF-8')
  end
end

def test_name(example)
  "#{example.metadata[:described_class]}
   #{example.metadata[:example_group][:description]}
   #{example.metadata[:description]}"
end

def entity_plus_id(entity_name, record_id)
  { eid: Base64.encode64("#{entity_name}-#{record_id}").tr('\=', "~Ç") }
end
