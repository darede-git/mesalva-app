# frozen_string_literal: true

require 'me_salva/payment/iugu/client'
require 'iugu'

module MeSalva
  module Payment
    module Iugu
      class PaymentMethod
        include MeSalva::Payment::Iugu::Client

        def initialize
          set_api_key
        end

        def fetch(customer_id, id)
          ::Iugu::PaymentMethod.fetch(customer_id: customer_id, id: id)
        end

        def create(customer, token)
          customer.payment_methods.create(
            description: 'default',
            token: token,
            set_as_default: true
          )
        end

        def search(customer_id)
          ::Iugu::PaymentMethod.search(customer_id: customer_id).results
        end
      end
    end
  end
end
