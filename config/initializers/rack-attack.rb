# frozen_string_literal: true
class Rack::Attack
  LOGIN_PATHS = ['/user/sign_in',
                 '/teacher/sign_in',
                 '/admin/sign_in'].freeze

  SENSIVE_PATHS = ['/checkouts'].freeze

  BLACKLIST = ENV['IP_BLACKLIST'].split(',')
  REQUEST_RATE_LIMIT = ENV['REQUEST_RATE_LIMIT'].to_i
  CHECKOUT_RATE_LIMIT = ENV['CHECKOUT_RATE_LIMIT'].to_i

  Rack::Attack.safelist_ip(ENV['APP_ENEM_BFF_IP_RACK_WHITELIST'])

  # Blocks preflight access control with a 403 status code
  Rack::Attack.blocklist('block blacklist') do |req|
    BLACKLIST.include?(req.ip)
  end

  self.throttled_response = lambda do |env|
    headers = { 'Content-Type' => 'application/json',
                'Retry-After' => REQUEST_RATE_LIMIT }
    [ 429, headers, ['']]
  end

  throttle('req/ip', limit: REQUEST_RATE_LIMIT, period: 1.minute) do |req|
    req.ip
  end

  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if LOGIN_PATHS.include?(req.path) && req.post?
  end

  throttle('checkout/ip', limit: CHECKOUT_RATE_LIMIT, period: 1.minute) do |req|
    req.ip if SENSIVE_PATHS.include?(req.path) && req.post?
  end

  throttle('logins/email', limit: 5, period: 20.seconds) do |req|
    req.params['email'].presence if LOGIN_PATHS.include?(req.path) && req.post?
  end
end
