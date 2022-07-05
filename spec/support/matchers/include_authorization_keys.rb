# frozen_string_literal: true

RSpec::Matchers.define :include_authorization_keys do
  authorization_keys = %w[access-token
                          token-type
                          client
                          expiry
                          uid]
  match do |actual|
    actual & authorization_keys == authorization_keys
  end

  failure_message do
    'expect authorization keys to be in the response headers'
  end

  failure_message_when_negated do
    'expect authorization keys not to be in the response headers'
  end

  description do
    'checks response headers authorization keys'
  end
end
