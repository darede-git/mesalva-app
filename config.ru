# frozen_string_literal: true

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application

require 'rack/cors'

use Rack::Attack if ENV['FEATURE_FLAG_RACK_ATTACK']
use Rack::Cors do
  allow do
    origins ENV['KNOWN_HOSTS'].split(','),
            /mesalva-(frontend|admin)-qa-pr-(\d*)\.herokuapp\.com/,
            /(front|bff)-(admin|admin-redacao|gabarito|next|proxy|platform|lps|checkout|checkout-next)(?:-qa)?(?:-pr-(\d*))?\.herokuapp\.com/,
            /mesalva-admi(.*)\.herokuapp\.com/
    resource '*',
             headers: :any,
             expose: ['access-token',
                      'expiry',
                      'token-type',
                      'uid',
                      'client',
                      'x-date'],
             methods: %i[head options get post put patch delete]
  end
end
