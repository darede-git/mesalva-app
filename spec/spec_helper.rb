# frozen_string_literal: true

require 'factory_bot_rails'
require 'dotenv'
require 'pry'
Dotenv.load

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
end
