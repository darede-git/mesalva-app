# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.6'

gem 'rails', '5.2.1'

# Database
gem 'pg', '0.20'
gem 'redis'

# Web server
gem 'puma'

# Caching
gem 'connection_pool'
gem 'dalli'
gem 'kgio'
gem 'memcachier'
gem 'rack-cache', '1.9.0'

# Components for simplifying internal flows
gem 'mimemagic', '~> 0.3.10'
gem 'carrierwave'
gem 'carrierwave-base64'
gem 'fog'
gem 'mime-types'
gem 'mini_magick'
gem 'statesman'
gem 'rubyzip'

# 3rd party services
gem 'algoliasearch-rails'
gem 'elasticsearch-model', '5.1.0'
gem 'intercom'
gem 'iugu', git: 'https://github.com/mesalva/iugu-ruby'
gem 'pagarme'
gem 'samba-videos-api'
gem 'rdstation-ruby-client'

# Admin
gem 'activeadmin'
gem 'activeadmin_addons'
gem 'coffee-rails'
gem 'sass-rails'
gem 'sprockets'
gem 'uglifier'

# 3rd party servers
gem 'httparty'
gem 'typeform'
gem 'shortener'

# Presenters
gem 'active_model_serializers'
gem 'ancestry', '3.0.5'
gem 'api-pagination'
gem 'fast_jsonapi', '1.5'
gem 'will_paginate'

# Authentication
gem 'devise'
gem 'devise_invitable'
gem 'devise_token_auth'
gem 'omniauth'
gem 'jwt'

# Security
gem 'api-auth', git: 'https://github.com/mesalva/api_auth.git', branch: 'master'
gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'

# Tracking
gem 'brakeman'
gem 'newrelic_rpm'
gem 'rubocop', '~> 1.1'

# Operations and system
gem 'clockwork'
gem 'concurrent-ruby', '1.1.2'
gem 'sidekiq'
gem 'sidekiq-failures'

# Production code coverage
group :production do
  gem 'coverband'
end

group :development, :test do
  gem 'awesome_print'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'seedbank'
  gem 'rubocop-daemon', require: false

  if ENV['VSCODE_DEBUGGER'] == 'true'
    gem 'ruby-debug-ide', '~> 0.7.3'
    gem 'debase', '~> 0.2.4.1'
  end
end

group :development do
  gem 'letter_opener'
  gem 'listen'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'guard-rspec', require: false
end

group :test do
  gem 'codeclimate-test-reporter'
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'shoulda-matchers', require: false
  gem 'simplecov'
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end
