# frozen_string_literal: true

require 'pagarme'

module MeSalva
  module Payment
    module Pagarme
      module Client
        def set_api_key
          ::PagarMe.api_key = ENV['PAGARME_API_KEY']
          # PagarMe.encryption_key = ENV['PAGARME_ENCRYPTION_KEY']
        end
      end
    end
  end
end
