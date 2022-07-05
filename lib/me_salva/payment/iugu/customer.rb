# frozen_string_literal: true

require 'me_salva/payment/iugu/client'
require 'iugu'

module MeSalva
  module Payment
    module Iugu
      class Customer
        include MeSalva::Payment::Iugu::Client

        def initialize
          set_api_key
        end

        def fetch(customer_id)
          ::Iugu::Customer.fetch(customer_id)
        end

        def create(attributes)
          ::Iugu::Customer.create(attributes)
        end

        def search(email)
          ::Iugu::Customer.search(query: "\"#{email}\"",
                                  limit: 1,
                                  sortBy: { created_at: 'DESC' })
                          .results
                          .first
        end
      end
    end
  end
end
