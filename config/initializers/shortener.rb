# frozen_string_literal: true

Shortener.unique_key_length = 10
Shortener.default_redirect = "#{ENV['DEFAULT_URL']}/"
# Shortener.charset = :alphanumcase
# Shortener.auto_clean_url = true
# Shortener.forbidden_keys.concat %w()
Shortener.ignore_robots = true
